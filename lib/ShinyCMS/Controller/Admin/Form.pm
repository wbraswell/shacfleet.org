package ShinyCMS::Controller::Admin::Form;

use Moose;
use namespace::autoclean;

BEGIN { extends 'ShinyCMS::Controller'; }


=head1 NAME

ShinyCMS::Controller::Admin::Form

=head1 DESCRIPTION

Controller for ShinyCMS form administration actions.

=head1 METHODS

=cut


=head2 base

Set up path and stash some useful stuff.

=cut

sub base : Chained( '/base' ) : PathPart( 'admin/form' ) : CaptureArgs( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash the upload_dir setting
	$c->stash->{ upload_dir } = $c->config->{ upload_dir };

	# Stash the controller name
	$c->stash->{ controller } = 'Admin::Form';
}


=head2 list_forms

List forms for admin interface.

=cut

sub list_forms : Chained( 'base' ) : PathPart( '' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view CMS forms
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of forms', 
		role   => 'CMS Form Admin',
	});
	
	my @forms = $c->model( 'DB::CmsForm' )->search;
	$c->stash->{ forms } = \@forms;
}


=head2 add_form

Add a new form.

=cut

sub add_form : Chained( 'base' ) : PathPart( 'add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add CMS forms
	return 0 unless $self->user_exists_and_can($c, {
		action => 'add a new form', 
		role   => 'CMS Form Admin',
	});
	
	# Fetch the list of available templates
	$c->stash->{ templates } = $c->forward( 'get_template_filenames' );
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/form/edit_form.tt';
}


=head2 edit_form

Edit an existing form.

=cut

sub edit_form : Chained( 'base' ) : PathPart( 'edit' ) : Args( 1 ) {
	my ( $self, $c, $url_name ) = @_;
	
	# Check to make sure user has the right to edit CMS forms
	return 0 unless $self->user_exists_and_can($c, {
		action => 'edit a form', 
		role   => 'CMS Form Admin',
	});
	
	# Get the form
	my $form = $c->model( 'DB::CmsForm' )->find({
		url_name => $url_name,
	});
	$c->stash->{ form } = $form;
	
	# Fetch the list of available templates
	$c->stash->{ templates } = $c->forward( 'get_template_filenames' );
}
	

=head2 edit_form_do

Process a form edit.

=cut

sub edit_form_do : Chained( 'base' ) : PathPart( 'edit-form-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit CMS forms
	return 0 unless $self->user_exists_and_can($c, {
		action => 'update forms', 
		role   => 'CMS Form Admin',
	});
	
	# Fetch the form, if one was specified
	my $form;
	if ( $c->request->param( 'form_id' ) ) {
		$form = $c->model( 'DB::CmsForm' )->find({
			id => $c->request->param( 'form_id' ),
		});
	}
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		$form->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Page deleted';
		
		# Bounce to the list of CMS forms
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Extract form details from request
	my $has_captcha = 1 if $c->request->param( 'has_captcha' );
	my $details = {
		name        => $c->request->param( 'name'     ) || undef,
		redirect    => $c->request->param( 'redirect' ) || undef,
		action      => $c->request->param( 'action'   ) || undef,
		email_to    => $c->request->param( 'email_to' ) || undef,
		template    => $c->request->param( 'template' ) || undef,
		has_captcha => $has_captcha || 0,
	};
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	$details->{ url_name } = $url_name;
	
	if ( $form ) {
		$form->update( $details );
	}
	else {
		$form = $c->model( 'DB::CmsForm' )->create ( $details );
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Details updated';
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'edit', $form->url_name ) );
}


=head2 get_template_filenames

Get a list of available template filenames.

=cut

sub get_template_filenames : Private {
	my ( $self, $c ) = @_;
	
	my $template_dir = $c->path_to( 'root/emails' );
	opendir( my $template_dh, $template_dir ) 
		or die "Failed to open template directory $template_dir: $!";
	my @templates;
	foreach my $filename ( readdir( $template_dh ) ) {
		next if $filename =~ m/^\./; # skip hidden files
		next if $filename =~ m/~$/;  # skip backup files
		push @templates, $filename;
	}
	
	return \@templates;
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

