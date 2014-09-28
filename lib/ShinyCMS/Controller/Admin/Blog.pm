package ShinyCMS::Controller::Admin::Blog;

use Moose;
use MooseX::Types::Moose qw/ Str /;
use namespace::autoclean;

BEGIN { extends 'ShinyCMS::Controller'; }


use XML::Feed;
use Encode;


=head1 NAME

ShinyCMS::Controller::Admin::Blog

=head1 DESCRIPTION

Controller for ShinyCMS blog admin features.

=cut


has comments_default => (
	isa     => Str,
	is      => 'ro',
	default => 'Yes',
);

has hide_new_posts => (
	isa     => Str,
	is      => 'ro',
	default => 'No',
);


=head1 METHODS

=cut


=head2 base

Set up path and stash some useful info.

=cut

sub base : Chained( '/base' ) : PathPart( 'admin/blog' ) : CaptureArgs( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash the upload_dir setting
	$c->stash->{ upload_dir } = $c->config->{ upload_dir };
	
	# Stash the name of the controller
	$c->stash->{ controller } = 'Admin::Blog';
}


=head2 generate_atom_feed

Generate the atom feed.

=cut

sub generate_atom_feed {
	my ( $self, $c ) = @_;
	
	# Get the 10 most recent posts
	my $posts = $self->get_visible_posts( $c, 1, 10 );
	my @posts = $posts->all;
	
	my $now = DateTime->now;
	my $domain    = $c->config->{ domain    } || 'shinycms.org';
	my $site_name = $c->config->{ site_name } || 'ShinySite';
	
	my $feed = XML::Feed->new( 'Atom' );
	$feed->id(          'tag:'. $domain .',2010:blog' );
	$feed->self_link(   $c->uri_for( '/static', 'feeds', 'atom.xml' ) );
	$feed->link(        $c->uri_for( '/blog' )               );
	$feed->modified(    $now                                 );
	$feed->title(       $site_name                           );
	$feed->description( 'Recent blog posts from '.$site_name );
	
	# Process the entries
	foreach my $post ( @posts ) {
		my $posted = $post->posted;
		$posted->set_time_zone( 'UTC' );
		
		my $url = $c->uri_for( '/blog', $posted->year, $posted->month, $post->url_title );
		my $id  = 'tag:'. $domain .',2010:blog:'. $posted->year .':'. $posted->month .':'. $post->url_title;
		
		my $author = $post->author->display_name || $post->author->username;
		
		my $entry = XML::Feed::Entry->new( 'Atom' );
		
		$entry->id(       $id          );
		$entry->link(     $url         );
		$entry->author(   $author      );
		$entry->modified( $posted      );
		$entry->title(    $post->title );
		$entry->content(  $post->body  );
		
		$feed->add_entry( $entry );
	}
	
	# Write feed to file
	my $xml  = $feed->as_xml;
	my $file = $c->path_to( 'root', 'static', 'feeds' ) .'/atom.xml';
	open my $fh, '>', $file or die "Failed to open atom.xml for writing: $!";
	print $fh $xml, "\n"    or die "Failed to write to atom.xml: $!";
	close $fh               or die "Failed to close atom.xml after writing: $!";
}


=head2 get_posts

Get the recent posts, including forward-dated ones

=cut

sub get_posts {
	my ( $self, $c, $page, $count ) = @_;
	
	$page  ||= 1;
	$count ||= 20;
	
	my $posts = $c->model( 'DB::BlogPost' )->search(
		{},
		{
			order_by => { -desc => 'posted' },
			page     => $page,
			rows     => $count,
		},
	);
	
	return $posts;
}


=head2 get_visible_posts

Get the recent posts, not including hidden or forward-dated ones

=cut

sub get_visible_posts {
	my ( $self, $c, $page, $count ) = @_;
	
	$page  ||= 1;
	$count ||= 20;
	
	my $posts = $c->model( 'DB::BlogPost' )->search(
		{
			hidden   => 0,
		},
		{
			order_by => { -desc => 'posted' },
			page     => $page,
			rows     => $count,
		},
	);
	
	return $posts;
}


=head2 get_tags

Get the tags for a post, or for the whole blog if no post specified

=cut

sub get_tags {
	my ( $self, $c, $post_id ) = @_;
	
	if ( $post_id ) {
		my $tagset = $c->model( 'DB::Tagset' )->find({
			resource_id   => $post_id,
			resource_type => 'BlogPost',
		});
		return $tagset->tag_list if $tagset;
	}
	else {
		my @tagsets = $c->model( 'DB::Tagset' )->search({
			resource_type => 'BlogPost',
		});
		my @taglist;
		foreach my $tagset ( @tagsets ) {
			push @taglist, @{ $tagset->tag_list };
		}
		my %taghash;
		foreach my $tag ( @taglist ) {
			$taghash{ $tag } = 1;
		}
		my @tags = keys %taghash;
		@tags = sort { lc $a cmp lc $b } @tags;
		return \@tags;
	}
	
	return;
}


=head2 index

Forward to list_posts

=cut

sub index : Chained( 'base' ) : PathPart( '' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	$c->go( 'list_posts' );
}


=head2 list_posts

Lists all blog posts, for use in admin area.

=cut

sub list_posts : Chained( 'base' ) : PathPart( 'posts' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of blog posts
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of blog posts', 
		role   => 'Blog Author',
	});
	
	my $page  ||= 1;
	my $count ||= 20;
	
	my $posts = $self->get_posts( $c, $page, $count );
	
	$c->stash->{ blog_posts } = $posts;
}


=head2 add_post

Add a new blog post.

=cut

sub add_post : Chained( 'base' ) : PathPart( 'post/add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add a blog post
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a blog post', 
		role     => 'Blog Author',
		redirect => '/blog',
	});
	
	# Pass in the list of blog authors
	my @authors = $c->model( 'DB::Role' )->search({ role => 'Blog Author' })
		->single->users->all;
	$c->stash->{ authors } = \@authors;
	
	# Find default comment setting and pass through
	$c->stash->{ comments_default_on } = 'YES' 
		if uc $self->comments_default eq 'YES';
	
	# Stash 'hide new posts' setting
	$c->stash->{ hide_new_posts } = 1 if uc $self->hide_new_posts eq 'YES';
	
	$c->stash->{ template } = 'admin/blog/edit_post.tt';
}


=head2 make_url_title

Create a URL title for a blog post

=cut

sub make_url_title {
	my( $self, $url_title ) = @_;
	
	$url_title =~ s/\s+/-/g;	# Change spaces into hyphens
	$url_title =~ s/[^-\w]//g;	# Remove anything that's not in: A-Z, a-z, 0-9, _ or -
	$url_title =~ s/-+/-/g;		# Change multiple hyphens to single hyphens
	$url_title =~ s/^-//;		# Remove hyphen at start, if any
	$url_title =~ s/-$//;		# Remove hyphen at end, if any
	
	return lc $url_title;
}


=head2 add_post_do

Process adding a blog post.

=cut

sub add_post_do : Chained( 'base' ) : PathPart( 'post/add-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add a blog post
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a blog post', 
		role     => 'Blog Author',
		redirect => '/blog',
	});
	
	# Tidy up the URL title
	my $url_title = $c->request->param( 'url_title' );
	$url_title  ||= $c->request->param( 'title'     );
	$url_title = $self->make_url_title( $url_title  );
	
	# TODO: catch and fix duplicate year/month/url_title combinations
	
	my $posted;
	if ( $c->request->param( 'posted_date' ) ) {
		$posted = $c->request->param( 'posted_date' ) .' '. $c->request->param( 'posted_time' );
	}
	
	my $author_id = $c->user->id;
	if ( $c->user->has_role( 'Blog Admin' ) and $c->request->param( 'author' ) ) {
		$author_id = $c->request->param( 'author' );
	}
	
	# Add the post
	my $hidden = $c->request->param( 'hidden' ) ? 1 : 0;
	my $post = $c->model( 'DB::BlogPost' )->create({
		blog      => 1,
		title     => $c->request->param( 'title'  ) || undef,
		url_title => $url_title || undef,
		author    => $author_id,
		posted    => $posted,
		hidden    => $hidden,
		body      => $c->request->param( 'body'   ) || undef,
	});
	
	# Create a related discussion thread, if requested
	if ( $c->request->param( 'allow_comments' ) ) {
		my $discussion = $c->model( 'DB::Discussion' )->create({
			resource_id   => $post->id,
			resource_type => 'BlogPost',
		});
		$post->update({ discussion => $discussion->id });
	}
	
	# Process the tags
	if ( $c->request->param('tags') ) {
		my $tagset = $c->model( 'DB::Tagset' )->create({
			resource_id   => $post->id,
			resource_type => 'BlogPost',
		});
		my @tags = sort split /\s*,\s*/, $c->request->param('tags');
		foreach my $tag ( @tags ) {
			$tagset->tags->create({
				tag => $tag,
			});
		}
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Blog post added';
	
	# Rebuild the atom feed
	$c->forward( 'Admin::Blog', 'generate_atom_feed' ) unless $hidden;
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'post', $post->id, 'edit' ) );
}


=head2 get_post
Get details of an existing blog post.

=cut

sub get_post : Chained( 'base' ) : PathPart( 'post' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $post_id ) = @_;
	
	# Stash the blog post
	$c->stash->{ blog_post } = $c->model( 'DB::BlogPost' )->find({
		id => $post_id,
	});
	# Stash the tags
	$c->stash->{ blog_post_tags } = $self->get_tags( $c, $post_id );
}


=head2 edit_post

Edit an existing blog post.

=cut

sub edit_post : Chained( 'get_post' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit a blog post
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a blog post', 
		role     => 'Blog Author',
		redirect => '/blog',
	});
	
	my @authors = $c->model( 'DB::Role' )->search({ role => 'Blog Author' })
		->single->users->all;
	$c->stash->{ authors } = \@authors;
}


=head2 edit_post_do

Process an update.

=cut

sub edit_post_do : Chained( 'get_post' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit a blog post
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a blog post', 
		role     => 'Blog Author',
		redirect => '/blog',
	});
	
	# Get the post
	my $post   = $c->stash->{ blog_post };
	my $tagset = $c->model( 'DB::Tagset' )->find({
		resource_id   => $post->id,
		resource_type => 'BlogPost',
	});
	
	# Process deletions
	if ( defined $c->request->param( 'delete' ) && $c->request->param( 'delete' ) eq 'Delete' ) {
		$tagset->tags->delete if $tagset;
		$tagset->delete if $tagset;
		$post->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Post deleted';
		
		# Rebuild the atom feed
		$self->generate_atom_feed( $c );
		
		# Bounce to the list of posts
		$c->response->redirect( $c->uri_for( 'posts' ) );
		return;
	}
	
	# Tidy up the URL title
	my $url_title = $c->request->param( 'url_title' );
	$url_title  ||= $c->request->param( 'title'     );
	$url_title = $self->make_url_title( $url_title  );
	
	# TODO: catch and fix duplicate year/month/url_title combinations
	
	my $posted = $c->request->param( 'posted_date' ) .' '. $c->request->param( 'posted_time' );
	
	my $author_id = $post->author->id;
	if ( $c->user->has_role( 'Blog Admin' ) and $c->request->param( 'author' ) ) {
		$author_id = $c->request->param( 'author' );
	}
	
	# Perform the update
	my $hidden = $c->request->param( 'hidden' ) ? 1 : 0;
	$post->update({
		title     => $c->request->param( 'title'  ) || undef,
		url_title => $url_title || undef,
		author    => $author_id,
		posted    => $posted,
		hidden    => $hidden,
		body      => $c->request->param( 'body'   ) || undef,
	});
	
	# Create a related discussion thread, if requested
	if ( $c->request->param( 'allow_comments' ) and not $post->discussion ) {
		my $discussion = $c->model( 'DB::Discussion' )->create({
			resource_id   => $post->id,
			resource_type => 'BlogPost',
		});
		$post->update({ discussion => $discussion->id });
	}
	# Disconnect the related discussion thread, if requested
	# (leaves it orphaned, rather than deleting it)
	elsif ( $post->discussion and not $c->request->param( 'allow_comments' ) ) {
		$post->update({ discussion => undef });
	}
	
	# Process the tags
	if ( $tagset ) {
		my $tags = $tagset->tags;
		$tags->delete;
		if ( $c->request->param('tags') ) {
			my @tags = sort split /\s*,\s*/, $c->request->param('tags');
			foreach my $tag ( @tags ) {
				$tagset->tags->create({
					tag => $tag,
				});
			}
		}
		else {
			$tagset->delete;
		}
	}
	elsif ( $c->request->param('tags') ) {
		my $tagset = $c->model( 'DB::Tagset' )->create({
			resource_id   => $post->id,
			resource_type => 'BlogPost',
		});
		my @tags = sort split /\s*,\s*/, $c->request->param('tags');
		foreach my $tag ( @tags ) {
			$tagset->tags->create({
				tag => $tag,
			});
		}
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Blog post updated';
	
	# Rebuild the atom feed
	$self->generate_atom_feed( $c ) unless $hidden;
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'post', $post->id, 'edit' ) );
}



=head1 AUTHOR

Denny de la Haye <2014@denny.me>

=head1 COPYRIGHT

ShinyCMS is copyright (c) 2009-2014 Shiny Ideas (www.shinyideas.co.uk).

=head1 LICENSE

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU Affero General Public License as published by 
the Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

You should have received a copy of the GNU Affero General Public License 
along with this program (see docs/AGPL-3.0.txt).  If not, see 
http://www.gnu.org/licenses/

=cut

__PACKAGE__->meta->make_immutable;

1;

