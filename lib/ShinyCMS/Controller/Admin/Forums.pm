package ShinyCMS::Controller::Admin::Forums;

use Moose;
use namespace::autoclean;

BEGIN { extends 'ShinyCMS::Controller'; }


=head1 NAME

ShinyCMS::Controller::Admin::Forums

=head1 DESCRIPTION

Controller for ShinyCMS forum admin features.

=head1 METHODS

=cut


=head2 base

Set up path and stash some useful info.

=cut

sub base : Chained( '/base' ) : PathPart( 'admin/forums' ) : CaptureArgs( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash the controller name
	$c->stash->{ controller } = 'Admin::Forums';
}


=head2 index

Bounce back to forums on main site unless user is a forums admin.

=cut

sub index : Path : Args( 0 ) {
    my ( $self, $c ) = @_;

	# Check to make sure user has the required permissions
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'administrate the forums', 
		role     => 'Forum Admin',
		redirect => '/forums'
	});
	
    $c->go( 'list' );
}


# ========== ( Posts ) ==========

=head2 stash_post

Stash details relating to a post.

=cut

sub stash_post : Chained( 'base' ) : PathPart( 'post' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $post_id ) = @_;
	
	$c->stash->{ forum_post } = $c->model( 'DB::ForumPost' )->find({
		id => $post_id
	});
	
	unless ( $c->stash->{ forum_post } ) {
		$c->flash->{ error_msg } = 
			'Specified post not found - please try again.';
		$c->go( 'list_forums' );
	}
}


=head2 edit_post

Edit a forum post.

=cut

sub edit_post : Chained( 'stash_post' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Bounce if user isn't logged in and a forums admin
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a forum post', 
		role   => 'Forums Admin',
	});
}


=head2 edit_post_do

Process a forum post edit.

=cut

sub edit_post_do : Chained( 'stash_post' ) : PathPart( 'edit-post-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit forums
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a forum post', 
		role   => 'Forums Admin',
	});
	
	# Process deletions
	if ( $c->request->param( 'delete' ) eq 'Delete' ) {
		# Delete the comments thread
		$c->stash->{ forum_post }->discussion->comments->delete;
		# Delete the post
		$c->stash->{ forum_post }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Forum post deleted';
		
		# Bounce to the 'view all forums' page
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Check for a collision in the menu_position settings for this section
	my $collision = $c->stash->{ forum_post }->forum->forum_posts->search({
		display_order => $c->request->param( 'display_order' ),
	})->count;
	
	# Update forum post
	$c->stash->{ forum_post }->update({
		title         => $c->request->param( 'title'         ) || undef,
		url_title     => $c->request->param( 'url_title'     ) || undef,
		body          => $c->request->param( 'body'          ) || undef,
		display_order => $c->request->param( 'display_order' ) || undef,
	});
	
	# Update the display_order for other sticky posts in this forum, if necessary
	if ( $collision ) {
		$c->stash->{ forum_post }->forum->forum_posts->search({
			id            => { '!=' => $c->stash->{ forum_post }->id },
			display_order => { '>=' => $c->request->param( 'display_order' ) },
		})->update({
			display_order => \'display_order + 1',
		});
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Forum post updated';
	
	# Bounce back to the edit page
	$c->response->redirect( 
		$c->uri_for( 'post', $c->stash->{ forum_post }->id, 'edit' )
	);
}


# ========== ( Forums ) ==========

=head2 list_forums

List all the forums.

=cut

sub list_forums : Chained( 'base' ) : PathPart( 'list' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view CMS sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of forums', 
		role   => 'Forums Admin',
	});
	
	my @sections = $c->model( 'DB::ForumSection' )->search(
		{},
		{ order_by => 'display_order' },
	);
	$c->stash->{ sections } = \@sections;
}


=head2 stash_forum

Stash details relating to a forum.

=cut

sub stash_forum : Chained( 'base' ) : PathPart( '' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $forum_id ) = @_;
	
	$c->stash->{ forum } = $c->model( 'DB::Forum' )->find( { id => $forum_id } );
	
	unless ( $c->stash->{ forum } ) {
		$c->flash->{ error_msg } = 
			'Specified forum not found - please select from the options below';
		$c->go( 'list_forums' );
	}
}


=head2 add_forum

Add a forum.

=cut

sub add_forum : Chained( 'base' ) : PathPart( 'add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'add a new section', 
		role   => 'Forums Admin',
	});
	
	my @sections = $c->model( 'DB::ForumSection' )->search(
		{},
		{ order_by => 'display_order' },
	);
	$c->stash->{ sections } = \@sections;
	
	$c->stash->{ template } = 'admin/forums/edit_forum.tt';
}


=head2 add_forum_do

Process adding a forum.

=cut

sub add_forum_do : Chained( 'base' ) : PathPart( 'add-forum-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'add a new forum', 
		role   => 'Forums Admin',
	});
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Create forum
	my $forum = $c->model( 'DB::Forum' )->create({
		name          => $c->request->param( 'name'          ) || undef,
		url_name      => $url_name || undef,
		display_order => $c->request->param( 'display_order' ) || undef,
		description   => $c->request->param( 'description'   ) || undef,
		section       => $c->request->param( 'section'       ) || undef,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'New forum created';
	
	# Bounce back to the list of forums
	$c->response->redirect( $c->uri_for( 'list' ) );
}


=head2 edit_forum

Edit a forum.

=cut

sub edit_forum : Chained( 'stash_forum' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Bounce if user isn't logged in and a forums admin
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a forum', 
		role   => 'Forums Admin',
	});
	
	my @sections = $c->model( 'DB::ForumSection' )->search(
		{},
		{ order_by => 'display_order' },
	);
	$c->stash->{ sections } = \@sections;
}


=head2 edit_forum_do

Process a forum edit.

=cut

sub edit_forum_do : Chained( 'stash_forum' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit forums
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a forum', 
		role   => 'Forums Admin',
	});
	
	# Process deletions
	if ( $c->request->param( 'delete' ) eq 'Delete' ) {
		# Delete posts in forum
		$c->stash->{ forum }->forum_posts->delete;
		# Delete forum
		$c->stash->{ forum }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Forum deleted';
		
		# Bounce to the 'view all forums' page
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Update forum
	$c->stash->{ forum }->update({
		name          => $c->request->param( 'name'          ) || undef,
		url_name      => $c->request->param( 'url_name'      ) || undef,
		display_order => $c->request->param( 'display_order' ) || undef,
		description   => $c->request->param( 'description'   ) || undef,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Forum details updated';
	
	# Bounce back to the edit page
	$c->response->redirect( $c->uri_for( $c->stash->{ forum }->id, 'edit' ) );
}


# ========== ( Sections ) ==========

=head2 list_sections

List all the sections.

=cut

sub list_sections : Chained( 'base' ) : PathPart( 'list-sections' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view CMS sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of sections', 
		role   => 'Forums Admin',
	});

	my @sections = $c->model( 'DB::ForumSection' )->search(
		{},
		{ order_by => 'display_order' },
	);
	$c->stash->{ sections } = \@sections;
}


=head2 stash_section

Stash details relating to a section.

=cut

sub stash_section : Chained( 'base' ) : PathPart( 'section' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $section_id ) = @_;
	
	$c->stash->{ section } = $c->model( 'DB::ForumSection' )->find( { id => $section_id } );
	
	unless ( $c->stash->{ section } ) {
		$c->flash->{ error_msg } = 
			'Specified section not found - please select from the options below';
		$c->go( 'list_sections' );
	}
}


=head2 add_section

Add a section.

=cut

sub add_section : Chained( 'base' ) : PathPart( 'add-section' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'add a new section', 
		role   => 'Forums Admin',
	});
	
	$c->stash->{ template } = 'admin/forums/edit_section.tt';
}


=head2 add_section_do

Process adding a section.

=cut

sub add_section_do : Chained( 'base' ) : PathPart( 'add-section-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'add a new section', 
		role   => 'Forums Admin',
	});
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Create section
	my $section = $c->model( 'DB::ForumSection' )->create({
		name          => $c->request->param( 'name'          ) || undef,
		url_name      => $url_name || undef,
		display_order => $c->request->param( 'display_order' ) || undef,
		description   => $c->request->param( 'description'   ) || undef,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'New section created';
	
	# Bounce back to the list of sections
	$c->response->redirect( $c->uri_for( 'list-sections' ) );
}


=head2 edit_section

Edit a section.

=cut

sub edit_section : Chained( 'stash_section' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Bounce if user isn't logged in and a page admin
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a section', 
		role   => 'Forums Admin',
	});
}


=head2 edit_section_do

Process a section edit.

=cut

sub edit_section_do : Chained( 'stash_section' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit sections
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a section', 
		role   => 'Forums Admin',
	});
	
	# Process deletions
	if ( $c->request->param( 'delete' ) eq 'Delete' ) {
		# Delete posts in forums in section
		my @forums = $c->stash->{ section }->forums;
		foreach my $forum ( @forums ) {
			$forum->forum_posts->delete;
		}
		# Delete forums in section
		$c->stash->{ section }->forums->delete;
		# Delete section
		$c->stash->{ section }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Section deleted';
		
		# Bounce to the 'view all sections' page
		$c->response->redirect( $c->uri_for( 'list-sections' ) );
		return;
	}
	
	# Update section
	$c->stash->{ section }->update({
		name          => $c->request->param( 'name'          ) || undef,
		url_name      => $c->request->param( 'url_name'      ) || undef,
		display_order => $c->request->param( 'display_order' ) || undef,
		description   => $c->request->param( 'description'   ) || undef,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Section details updated';
	
	# Bounce back to the list of sections
	$c->response->redirect( $c->uri_for( 'section', $c->stash->{ section }->id, 'edit' ) );
}



=head1 AUTHOR

Denny de la Haye <2014@denny.me>

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

