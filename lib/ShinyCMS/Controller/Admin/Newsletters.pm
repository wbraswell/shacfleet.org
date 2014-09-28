package ShinyCMS::Controller::Admin::Newsletters;

use Moose;
use namespace::autoclean;

BEGIN { extends 'ShinyCMS::Controller'; }


use Text::CSV::Simple;


=head1 NAME

ShinyCMS::Controller::Admin::Newsletters - Catalyst Controller

=head1 DESCRIPTION

Controller for ShinyCMS newsletter admin features.

=head1 METHODS

=cut


=head2 index

Display a list of recent newsletters.

=cut

sub index : Path : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	$c->go( 'list' );
}


=head2 base

Set up path and stash some useful stuff.

=cut

sub base : Chained( '/base' ) : PathPart( 'admin/newsletters' ) : CaptureArgs( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash the upload_dir setting
	$c->stash->{ upload_dir } = $c->config->{ upload_dir };
	
	# Stash the controller name
	$c->stash->{ controller } = 'Admin::Newsletters';
}


=head2 get_element_types

Return a list of newsletter-element types.

=cut

sub get_element_types {
	# TODO: more elegant way of doing this
	
	return [ 'Short Text', 'Long Text', 'HTML', 'Image' ];
}



# ========== ( Newsletters ) ==========

=head2 list_newsletters

View a list of all newsletters.

=cut

sub list_newsletters : Chained( 'base' ) : PathPart( 'list' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of newsletters', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of newsletters
	my @newsletters = $c->model( 'DB::Newsletter' )->all;
	$c->stash->{ newsletters } = \@newsletters;
}


=head2 add_newsletter

Add a new newsletter.

=cut

sub add_newsletter : Chained( 'base' ) : PathPart( 'add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a newsletter', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/newsletters/edit_newsletter.tt';
}


=head2 add_newsletter_do

Process a newsletter addition.

=cut

sub add_newsletter_do : Chained( 'base' ) : PathPart( 'add-newsletter-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a newsletter', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Extract page details from form
	my $details = {
		title    => $c->request->param( 'title'    ) || undef,
		template => $c->request->param( 'template' ) || undef,
	};
	
	# Sanitise the url_title
	my $url_title = $c->request->param( 'url_title' );
	$url_title  ||= $c->request->param( 'title'     );
	$url_title   =~ s/\s+/-/g;
	$url_title   =~ s/-+/-/g;
	$url_title   =~ s/[^-\w]//g;
	$url_title   =  lc $url_title;
	$details->{ url_title } = $url_title || undef;
	
	# Add in the mailing list ID
	$details->{ list } = $c->request->param( 'mailing_list' );
	
	# Create page
	my $newsletter = $c->model( 'DB::Newsletter' )->create( $details );
	
	# Set up newsletter elements
	my @elements = $newsletter->template->newsletter_template_elements->all;
	
	foreach my $element ( @elements ) {
		my $el = $newsletter->newsletter_elements->create({
			name => $element->name,
			type => $element->type,
		});
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Newsletter added';
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'edit', $newsletter->id ) );
}


=head2 edit_newsletter

Edit a newsletter.

=cut

sub edit_newsletter : Chained( 'base' ) : PathPart( 'edit' ) : Args( 1 ) {
	my ( $self, $c, $nl_id ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a newsletter', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $nl_id,
	});
	
	if ( $c->stash->{ newsletter }->status eq 'Sent' ) {
		$c->flash->{ status_msg } = 'Cannot edit newsletter after sending';
		$c->response->redirect( $c->uri_for( 'list' ) );
	}
	
	$c->stash->{ types  } = get_element_types();
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Stash a list of images present in the images folder
	$c->stash->{ images } = $c->controller( 'Root' )->get_filenames( $c, 'images' );
	
	# Get page elements
	my @elements = $c->model( 'DB::NewsletterElement' )->search({
		newsletter => $c->stash->{ newsletter }->id,
	});
	$c->stash->{ newsletter_elements } = \@elements;
	
	# Build up 'elements' structure for use in cms-templates
	foreach my $element ( @elements ) {
		$c->stash->{ elements }->{ $element->name } = $element->content;
	}
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
}


=head2 edit_newsletter_do

Process a newsletter update.

=cut

sub edit_newsletter_do : Chained( 'base' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a newsletter', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Fetch the newsletter
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $c->request->param( 'newsletter_id' ),
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		$c->stash->{ newsletter }->newsletter_elements->delete;
		$c->stash->{ newsletter }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Newsletter deleted';
		
		# Bounce to the default page
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Extract newsletter details from form
	my $details = {
		title => $c->request->param( 'title' ),
	};
	
	# Sanitise the url_title
	my $url_title = $c->request->param( 'url_title' );
	$url_title  ||= $c->request->param( 'title'     );
	$url_title   =~ s/\s+/-/g;
	$url_title   =~ s/-+/-/g;
	$url_title   =~ s/[^-\w]//g;
	$url_title   =  lc $url_title;
	$details->{ url_title } = $url_title;
	
	# Add in the mailing list ID and the plain text version
	$details->{ list      } = $c->request->param( 'mailing_list' );
	$details->{ plaintext } = $c->request->param( 'plaintext'    );
	
	# Add in the template ID if one was passed in
	$details->{ template } = $c->request->param( 'template' ) if $c->request->param( 'template' );
	
	# Set the 'to send' date and time if they were pased in
	if ( $c->request->param( 'sent_pick' ) ) {
		$details->{ sent } = $c->request->param( 'sent_date' ) 
			.' '. $c->request->param( 'sent_time' );
	}
	else {
		# Wipe 'to send' date in case of user explicitly clearing it
		$details->{ sent } = undef;
	}
	
	# TODO: If template has changed, change element stack
	#if ( $c->request->param( 'template' ) != $c->stash->{ newsletter }->template->id ) {
		# Fetch old element set
		# Fetch new element set
		# Find the difference between the two sets
		# Add missing elements
		# Remove superfluous elements? Probably not - keep in case of reverts.
	#}
	
	# Extract newsletter elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		if ( $input =~ m/^type_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'type'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	
	# Update newsletter
	my $newsletter = $c->stash->{ newsletter }->update( $details );
	
	# Update newsletter elements
	foreach my $element ( keys %$elements ) {
		$c->stash->{ newsletter }->newsletter_elements->find({
			id => $element,
		})->update( $elements->{ $element } );
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Details updated';
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'edit', $newsletter->id ) );
}


=head2 preview

Preview a newsletter.

=cut

sub preview : Chained( 'base' ) PathPart( 'preview' ) : Args( 1 ) {
	my ( $self, $c, $nl_id ) = @_;
	
	# Check to make sure user has the right to preview newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action => 'preview page edits', 
		role   => 'Newsletter Admin',
	});
	
	# Get the newsletter details from the database
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $nl_id,
	});
	
	# Get the updated newsletter details from the form
	my $new_details = {
		title     => $c->request->param( 'title'     ) || 'No title given',
		url_title => $c->request->param( 'url_title' ) || 'No url_title given',
	};
	
	# Extract newsletter elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	# And set them up for insertion into the preview
	my $new_elements = {};
	foreach my $key ( keys %$elements ) {
		$new_elements->{ $elements->{ $key }->{ name } } = $elements->{ $key }->{ content };
	}
	
	# Stash site details
	$c->stash->{ site_name } = $c->config->{ site_name };
	$c->stash->{ site_url  } = $c->uri_for( '/' );
	
	# Stash recipient details
	$c->stash->{ recipient }->{ name  } = 'A. Person';
	$c->stash->{ recipient }->{ email } = 'a.person@example.com';
	
	# Set the TT template to use
	my $new_template;
	if ( $c->request->param( 'template' ) ) {
		$new_template = $c->model( 'DB::NewsletterTemplate' )->find({
			id => $c->request->param( 'template' )
		})->filename;
	}
	else {
		# Get template details from db
		$new_template = $c->stash->{ newsletter }->template->filename;
	}
	
	# Over-ride everything
	$c->stash->{ newsletter } = $new_details;
	$c->stash->{ elements   } = $new_elements;
	$c->stash->{ template   } = 'newsletters/newsletter-templates/'. $new_template;
	$c->stash->{ preview    } = 'preview';
}


=head2 test

Queue a newsletter for test delivery.

=cut

sub test : Chained( 'base' ) : PathPart( 'test' ) : Args( 1 ) {
	my ( $self, $c, $newsletter_id ) = @_;
	
	# Check to make sure user has the right to send newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'send a newsletter', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Fetch the newsletter
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $newsletter_id,
	});
	
	# Make sure the status progression is sane
	unless ( $c->stash->{ newsletter }->status eq 'Not sent' ) {
		$c->flash->{ status_msg } = 'Newsletter already sent.';
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Set delivery status to 'Test'
	$c->stash->{ newsletter }->update({
		status => 'Test',
		sent   => \'current_timestamp',
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Test newsletter queued for sending';
	
	# Bounce back to the list
	$c->response->redirect( $c->uri_for( 'list' ) );
}


=head2 queue

Queue a newsletter for immediate delivery.

=cut

sub queue : Chained( 'base' ) : PathPart( 'queue' ) : Args( 1 ) {
	my ( $self, $c, $newsletter_id ) = @_;
	
	# Check to make sure user has the right to send newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'send a newsletter', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Fetch the newsletter
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $newsletter_id,
	});
	
	# Make sure the status progression is sane
	unless ( $c->stash->{ newsletter }->status eq 'Not sent' ) {
		$c->flash->{ status_msg } = 'Newsletter already sent.';
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Set delivery status to 'Queued' and time sent to 'now'
	$c->stash->{ newsletter }->update({
		status => 'Queued',
		sent   => \'current_timestamp',
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Newsletter queued for sending';
	
	# Bounce back to the list
	$c->response->redirect( $c->uri_for( 'list' ) );
}


=head2 unqueue

Remove a newsletter from delivery queue.

=cut

sub unqueue : Chained( 'base' ) : PathPart( 'unqueue' ) : Args( 1 ) {
	my ( $self, $c, $newsletter_id ) = @_;
	
	# Check to make sure user has the right to unqueue newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'unqueue a newsletter', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Fetch the newsletter
	$c->stash->{ newsletter } = $c->model( 'DB::Newsletter' )->find({
		id => $newsletter_id,
	});
	
	# Make sure the status progression is sane
	unless ( $c->stash->{ newsletter }->status eq 'Queued' ) {
		$c->flash->{ status_msg } = 'Newsletter not in queue.';
		$c->response->redirect( $c->uri_for( 'list' ) );
		return;
	}
	
	# Set delivery status to 'Not sent'
	$c->stash->{ newsletter }->update({
		status => 'Not sent',
		sent   => undef,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Newsletter removed from delivery queue';
	
	# Bounce back to the list
	$c->response->redirect( $c->uri_for( 'list' ) );
}



# ========== ( Autoresponders ) ==========

=head2 list_autoresponders

View a list of all autoresponders.

=cut

sub list_autoresponders : Chained( 'base' ) : PathPart( 'autoresponders' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of newsletters', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of autoresponders
	my @autoresponders = $c->model( 'DB::Autoresponder' )->all;
	$c->stash->{ autoresponders } = \@autoresponders;
}


=head2 list_autoresponder_subscribers

View a list of subscribers to a specified autoresponder.

=cut

sub list_autoresponder_subscribers : Chained( 'get_autoresponder' ) : PathPart( 'subscribers' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of subscribers
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of subscribers for this autoresponder', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of subscribers
	my @subscribers;
	my @q_emails = $c->stash->{ autoresponder }->autoresponder_emails->first->queued_emails->all;
	foreach my $q_email ( @q_emails ) {
		my $recipient = $q_email->recipient;
		$recipient->{ subscribed } = $q_email->created;
		push @subscribers, $recipient;
	}
	$c->stash->{ subscribers } = \@subscribers;
}


=head2 delete_autoresponder_subscriber

View a list of subscribers to a specified autoresponder.

=cut

sub delete_autoresponder_subscriber : Chained( 'get_autoresponder' ) : PathPart( 'delete-subscriber' ) : Args( 1 ) {
	my ( $self, $c, $recipient_id ) = @_;
	
	# Check to make sure user has the right to delete subscribers
	return 0 unless $self->user_exists_and_can($c, {
		action => 'delete a subscriber from an autoresponder', 
		role   => 'Newsletter Admin',
	});
	
	my @email_ids = $c->stash->{ autoresponder }->autoresponder_emails->get_column('id')->all;
	my $q_emails  = $c->model('DB::QueuedEmail')->search({
		recipient => $recipient_id,
		email     => { -in => \@email_ids },
	});
	$q_emails->delete if $q_emails->count > 0;
	
	# Redirect to 'list subscribers' page
	my $url = $c->uri_for( 
		'autoresponder', $c->stash->{ autoresponder }->id, 'subscribers'
	);
	$c->response->redirect( $url );
}


=head2 add_autoresponder

Add a new autoresponder.

=cut

sub add_autoresponder : Chained( 'base' ) : PathPart( 'autoresponder/add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add autoresponders
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add an autoresponder', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/newsletters/edit_autoresponder.tt';
}


=head2 add_autoresponder_do

Process adding an autoresponder

=cut

sub add_autoresponder_do : Chained( 'base' ) : PathPart( 'autoresponder/add/do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add autoresponders
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add an autoresponder', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Check we have the minimum details
	unless ( $c->request->param('name') ) {
		$c->flash->{ error_msg } = 'You must set a name.';
		my $url = $c->uri_for( 'autoresponder', 'add' );
		$c->response->redirect( $url );
		$c->detach;
	}
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Add the autoresponder
	my $has_captcha = 1 if $c->request->param( 'has_captcha' );
	my $ar = $c->model('DB::Autoresponder')->create({
		name         => $c->request->param( 'name'         ),
		url_name     => $url_name,
		description  => $c->request->param( 'description'  ),
		mailing_list => $c->request->param( 'mailing_list' ) || undef,
		has_captcha  => $has_captcha || 0,
	});
	
	# Redirect to edit page
	my $url = $c->uri_for( 'autoresponder', $ar->id, 'edit' );
	$c->response->redirect( $url );
}


=head2 get_autoresponder

Get details of an autoresponder.

=cut

sub get_autoresponder : Chained( 'base' ) : PathPart( 'autoresponder' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $ar_id ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit an autoresponder', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ autoresponder } = $c->model( 'DB::Autoresponder' )->find({
		id => $ar_id,
	});
	
	unless ( $c->stash->{ autoresponder } ) {
		$c->flash->{ error_msg } = 'Failed to find details of specified autoresponder.';
		$c->detach;
	}
}


=head2 edit_autoresponder

Edit an autoresponder.

=cut

sub edit_autoresponder : Chained( 'get_autoresponder' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash a list of images present in the images folder
	$c->stash->{ images } = $c->controller( 'Root' )->get_filenames( $c, 'images' );
	
	# Get autoresponder emails
	my @emails = $c->model( 'DB::AutoresponderEmail' )->search(
		{
			autoresponder => $c->stash->{ autoresponder }->id,
		},
		{
			order_by => 'delay',
		}
	)->all;
	$c->stash->{ autoresponder_emails } = \@emails;
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
}


=head2 edit_autoresponder_do

Process updating an autoresponder

=cut

sub edit_autoresponder_do : Chained( 'get_autoresponder' ) : PathPart( 'edit/do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit autoresponders
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit an autoresponder', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for,
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		my @ar_emails = $c->stash->{ autoresponder }->autoresponder_emails->all;
		foreach my $ar_email ( @ar_emails ) {
			$ar_email->autoresponder_email_elements->delete;
		}
		$c->stash->{ autoresponder }->autoresponder_emails->delete;
		$c->stash->{ autoresponder }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Autoresponder deleted';
		
		# Redirect to the list of autoresponders page
		$c->response->redirect( $c->uri_for( 'autoresponders' ) );
		return;
	}
	
	# Check we have the minimum details
	unless ( $c->request->param('name') ) {
		$c->flash->{ error_msg } = 'You must set a name.';
		my $url = $c->uri_for( 
			'autoresponder', $c->stash->{ autoresponder }->id, 'edit'
		);
		$c->response->redirect( $url );
		$c->detach;
	}
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Update the autoresponder
	my $has_captcha = 1 if $c->request->param( 'has_captcha' );
	$c->stash->{ autoresponder }->update({
		name         => $c->request->param( 'name'         ),
		url_name     => $url_name,
		description  => $c->request->param( 'description'  ),
		mailing_list => $c->request->param( 'mailing_list' ) || undef,
		has_captcha  => $has_captcha || 0,
	});
	
	# Redirect to edit page
	my $url = $c->uri_for( 
		'autoresponder', $c->stash->{ autoresponder }->id, 'edit'
	);
	$c->response->redirect( $url );
}


=head2 add_autoresponder_email

Add a new autoresponder email.

=cut

sub add_autoresponder_email : Chained( 'get_autoresponder' ) : PathPart( 'email/add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add autoresponder emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add an autoresponder email', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/newsletters/edit_autoresponder_email.tt';
}


=head2 add_autoresponder_email_do

Process a autoresponder email addition.

=cut

sub add_autoresponder_email_do : Chained( 'get_autoresponder' ) : PathPart( 'email/add-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add autoresponder emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add an autoresponder email', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Extract email details from form
	my $details = {
		subject  => $c->request->param( 'subject'  ) || undef,
		delay    => $c->request->param( 'delay'    ) || 0,
		template => $c->request->param( 'template' ) || undef,
	};
	
	# Create email
	my $email = $c->stash->{ autoresponder }->autoresponder_emails->create( $details );
	
	# Set up email elements
	my @elements = $email->template->newsletter_template_elements->all;
	
	foreach my $element ( @elements ) {
		my $el = $email->autoresponder_email_elements->create({
			name => $element->name,
			type => $element->type,
		});
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Email added';
	
	# Bounce back to the 'edit' page
	my $uri = $c->uri_for( 
		'autoresponder', $c->stash->{ autoresponder }->id, 'email', $email->id, 'edit'
	);
	$c->response->redirect( $uri );
}


=head2 get_autoresponder_email

Get details of an autoresponder email.

=cut

sub get_autoresponder_email : Chained( 'get_autoresponder' ) : PathPart( 'email' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $email_id ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit an autoresponder email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ autoresponder_email } = $c->model( 'DB::AutoresponderEmail' )->find({
		id => $email_id,
	});
	
	unless ( $c->stash->{ autoresponder_email } ) {
		$c->flash->{ error_msg } = 'Failed to find details of specified autoresponder email.';
		$c->detach;
	}
}


=head2 edit_autoresponder_email

Edit a autoresponder_email.

=cut

sub edit_autoresponder_email : Chained( 'get_autoresponder_email' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit autoresponder_emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit an autoresponder email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ types  } = get_element_types();
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Stash a list of images present in the images folder
	$c->stash->{ images } = $c->controller( 'Root' )->get_filenames( $c, 'images' );
	
	# Get page elements
	my @elements = $c->model( 'DB::AutoresponderEmailElement' )->search({
		email => $c->stash->{ autoresponder_email }->id,
	});
	$c->stash->{ autoresponder_email_elements } = \@elements;
	
	# Build up 'elements' structure for use in cms-templates
	foreach my $element ( @elements ) {
		$c->stash->{ elements }->{ $element->name } = $element->content;
	}
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
}


=head2 edit_autoresponder_email_do

Process a autoresponder_email update.

=cut

sub edit_autoresponder_email_do : Chained( 'get_autoresponder_email' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit autoresponder_emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a autoresponder_email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		$c->stash->{ autoresponder_email }->autoresponder_email_elements->delete;
		$c->stash->{ autoresponder_email }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'autoresponder_email deleted';
		
		# Redirect to the autoresponder's edit page
		my $uri = $c->uri_for( 'autoresponder', $c->stash->{ autoresponder }->id, 'edit' );
		$c->response->redirect( $uri );
		return;
	}
	
	# Extract email details from form
	my $details = {
		subject   => $c->request->param( 'subject'   ) || undef,
		delay     => $c->request->param( 'delay'     ) || 0,
		plaintext => $c->request->param( 'plaintext' ) || undef,
	};
	
	# Add in the template ID if one was passed in
	$details->{ template } = $c->request->param( 'template' ) 
		if $c->request->param( 'template' );
	
	# TODO: If template has changed, change element stack
	#if ( $c->request->param( 'template' ) != $c->stash->{ autoresponder_email }->template->id ) {
		# Fetch old element set
		# Fetch new element set
		# Find the difference between the two sets
		# Add missing elements
		# Remove superfluous elements? Probably not - keep in case of reverts.
	#}
	
	# Extract email elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		if ( $input =~ m/^type_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'type'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	
	# Update autoresponder_email
	my $autoresponder_email = $c->stash->{ autoresponder_email }->update( $details );
	
	# Update autoresponder_email elements
	foreach my $element ( keys %$elements ) {
		$c->stash->{ autoresponder_email }->autoresponder_email_elements->find({
			id => $element,
		})->update( $elements->{ $element } );
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Details updated';
	
	# Bounce back to the 'edit' page
	my $uri = $c->uri_for( 
		'autoresponder', $c->stash->{ autoresponder }->id, 
		'email', $autoresponder_email->id, 'edit'
	);
	$c->response->redirect( $uri );
}


=head2 preview_email

Preview a autoresponder_email.

=cut

sub preview_email : Chained( 'get_autoresponder_email' ) PathPart( 'preview' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to preview autoresponder emails
	return 0 unless $self->user_exists_and_can($c, {
		action => 'preview autoresponder emails', 
		role   => 'Newsletter Admin',
	});
	
	# Get the updated email details from the form
	my $new_details = {
		title => $c->request->param( 'subject' ) || 'No title given',
	};
	
	# Extract email elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	# And set them up for insertion into the preview
	my $new_elements = {};
	foreach my $key ( keys %$elements ) {
		$new_elements->{ $elements->{ $key }->{ name } } = $elements->{ $key }->{ content };
	}
	
	# Stash site details
	$c->stash->{ site_name } = $c->config->{ site_name };
	$c->stash->{ site_url  } = $c->uri_for( '/' );
	
	# Stash recipient details
	$c->stash->{ recipient }->{ name  } = 'A. Person';
	$c->stash->{ recipient }->{ email } = 'a.person@example.com';
	
	# Set the TT template to use
	my $new_template;
	if ( $c->request->param( 'template' ) ) {
		$new_template = $c->model( 'DB::NewsletterTemplate' )->find({
			id => $c->request->param( 'template' )
		})->filename;
	}
	else {
		# Get template details from db
		$new_template = $c->stash->{ autoresponder_email }->template->filename;
	}
	
	# Over-ride everything
	$c->stash->{ autoresponder_email } = $new_details;
	$c->stash->{ elements } = $new_elements;
	$c->stash->{ template } = 'newsletters/newsletter-templates/'. $new_template;
	$c->stash->{ preview  } = 'preview';
}



# ========== ( Paid Lists ) ==========

=head2 list_paid_lists

View a list of all paid lists.

=cut

sub list_paid_lists : Chained( 'base' ) : PathPart( 'paid-lists' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of newsletters', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of paid lists
	my @paid_lists = $c->model( 'DB::PaidList' )->all;
	$c->stash->{ paid_lists } = \@paid_lists;
}


=head2 list_paid_list_subscribers

View a list of subscribers to a specified paid list.

=cut

sub list_paid_list_subscribers : Chained( 'get_paid_list' ) : PathPart( 'subscribers' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of subscribers
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view the list of subscribers for this paid list', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of subscribers
	my @subscribers;
	my @q_emails = $c->stash->{ paid_list }->paid_list_emails->first->queued_paid_emails->all;
	foreach my $q_email ( @q_emails ) {
		my $recipient = $q_email->recipient;
		$recipient->{ subscribed } = $q_email->created;
		push @subscribers, $recipient;
	}
	$c->stash->{ subscribers } = \@subscribers;
}


=head2 add_paid_list

Add a new paid list.

=cut

sub add_paid_list : Chained( 'base' ) : PathPart( 'paid-list/add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add paid lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a paid list', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/newsletters/edit_paid_list.tt';
}


=head2 add_paid_list_do

Process adding an paid list

=cut

sub add_paid_list_do : Chained( 'base' ) : PathPart( 'paid-list/add/do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add paid lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a paid list', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Check we have the minimum details
	unless ( $c->request->param('name') ) {
		$c->flash->{ error_msg } = 'You must set a name.';
		my $url = $c->uri_for( 'paid-list', 'add' );
		$c->response->redirect( $url );
		$c->detach;
	}
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Add the paid list
	my $has_captcha = 1 if $c->request->param( 'has_captcha' );
	my $ar = $c->model('DB::PaidList')->create({
		name         => $c->request->param( 'name'         ),
		url_name     => $url_name,
		description  => $c->request->param( 'description'  ),
		mailing_list => $c->request->param( 'mailing_list' ) || undef,
		has_captcha  => $has_captcha || 0,
	});
	
	# Redirect to edit page
	my $url = $c->uri_for( 'paid-list', $ar->id, 'edit' );
	$c->response->redirect( $url );
}


=head2 get_paid_list

Get details of a paid list.

=cut

sub get_paid_list : Chained( 'base' ) : PathPart( 'paid-list' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $ar_id ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'perform admin actions on a paid list', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ paid_list } = $c->model( 'DB::PaidList' )->find({
		id => $ar_id,
	});
	
	unless ( $c->stash->{ paid_list } ) {
		$c->flash->{ error_msg } = 'Failed to find details of specified paid list.';
		$c->detach;
	}
}


=head2 edit_paid_list

Edit a paid list.

=cut

sub edit_paid_list : Chained( 'get_paid_list' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Stash a list of images present in the images folder
	$c->stash->{ images } = $c->controller( 'Root' )->get_filenames( $c, 'images' );
	
	# Get paid list emails
	my @emails = $c->model( 'DB::PaidListEmail' )->search(
		{
			paid_list => $c->stash->{ paid_list }->id,
		},
		{
			order_by => 'delay',
		}
	)->all;
	$c->stash->{ paid_list_emails } = \@emails;
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
}


=head2 edit_paid_list_do

Process updating a paid list

=cut

sub edit_paid_list_do : Chained( 'get_paid_list' ) : PathPart( 'edit/do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit paid lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a paid list', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for,
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		my @ar_emails = $c->stash->{ paid_list }->paid_list_emails->all;
		foreach my $ar_email ( @ar_emails ) {
			$ar_email->paid_list_email_elements->delete;
		}
		$c->stash->{ paid_list }->paid_list_emails->delete;
		$c->stash->{ paid_list }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Paid list deleted';
		
		# Redirect to the list of paid lists
		$c->response->redirect( $c->uri_for( 'paid-lists' ) );
		return;
	}
	
	# Check we have the minimum details
	unless ( $c->request->param('name') ) {
		$c->flash->{ error_msg } = 'You must set a name.';
		my $url = $c->uri_for( 
			'paid-list', $c->stash->{ paid_list }->id, 'edit'
		);
		$c->response->redirect( $url );
		$c->detach;
	}
	
	# Sanitise the url_name
	my $url_name = $c->request->param( 'url_name' );
	$url_name  ||= $c->request->param( 'name'     );
	$url_name   =~ s/\s+/-/g;
	$url_name   =~ s/-+/-/g;
	$url_name   =~ s/[^-\w]//g;
	$url_name   =  lc $url_name;
	
	# Update the paid list
	my $has_captcha = 1 if $c->request->param( 'has_captcha' );
	$c->stash->{ paid_list }->update({
		name         => $c->request->param( 'name'         ),
		url_name     => $url_name,
		description  => $c->request->param( 'description'  ),
		mailing_list => $c->request->param( 'mailing_list' ) || undef,
		has_captcha  => $has_captcha || 0,
	});
	
	# Redirect to edit page
	my $url = $c->uri_for( 
		'paid-list', $c->stash->{ paid_list }->id, 'edit'
	);
	$c->response->redirect( $url );
}


=head2 add_paid_list_email

Add a new paid list email.

=cut

sub add_paid_list_email : Chained( 'get_paid_list' ) : PathPart( 'email/add' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add paid list emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a paid list email', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
	
	# Set the TT template to use
	$c->stash->{template} = 'admin/newsletters/edit_paid_list_email.tt';
}


=head2 add_paid_list_email_do

Process a paid list email addition.

=cut

sub add_paid_list_email_do : Chained( 'get_paid_list' ) : PathPart( 'email/add-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to add paid list emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a paid list email', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Extract email details from form
	my $details = {
		subject  => $c->request->param( 'subject'  ) || undef,
		delay    => $c->request->param( 'delay'    ) || 0,
		template => $c->request->param( 'template' ) || undef,
	};
	
	# Create email
	my $email = $c->stash->{ paid_list }->paid_list_emails->create( $details );
	
	# Set up email elements
	my @elements = $email->template->newsletter_template_elements->all;
	
	foreach my $element ( @elements ) {
		my $el = $email->paid_list_email_elements->create({
			name => $element->name,
			type => $element->type,
		});
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Email added';
	
	# Bounce back to the 'edit' page
	my $uri = $c->uri_for( 
		'paid-list', $c->stash->{ paid_list }->id, 'email', $email->id, 'edit'
	);
	$c->response->redirect( $uri );
}


=head2 get_paid_list_email

Get details of an paid_list email.

=cut

sub get_paid_list_email : Chained( 'get_paid_list' ) : PathPart( 'email' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $email_id ) = @_;
	
	# Check to make sure user has the right to edit newsletters
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit an paid list email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ paid_list_email } = $c->model( 'DB::PaidListEmail' )->find({
		id => $email_id,
	});
	
	unless ( $c->stash->{ paid_list_email } ) {
		$c->flash->{ error_msg } = 'Failed to find details of specified paid list email.';
		$c->detach;
	}
}


=head2 edit_paid_list_email

Edit a paid list_email.

=cut

sub edit_paid_list_email : Chained( 'get_paid_list_email' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit paid list_emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a paid list email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	$c->stash->{ types  } = get_element_types();
	
	# Stash the list of available mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
	
	# Stash a list of images present in the images folder
	$c->stash->{ images } = $c->controller( 'Root' )->get_filenames( $c, 'images' );
	
	# Get page elements
	my @elements = $c->model( 'DB::PaidListEmailElement' )->search({
		email => $c->stash->{ paid_list_email }->id,
	});
	$c->stash->{ paid_list_email_elements } = \@elements;
	
	# Build up 'elements' structure for use in cms-templates
	foreach my $element ( @elements ) {
		$c->stash->{ elements }->{ $element->name } = $element->content;
	}
	
	# Fetch the list of available templates
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ templates } = \@templates;
}


=head2 edit_paid_list_email_do

Process a paid list_email update.

=cut

sub edit_paid_list_email_do : Chained( 'get_paid_list_email' ) : PathPart( 'edit-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to edit paid list_emails
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a paid list_email', 
		role     => 'Newsletter Admin', 
		redirect => $c->uri_for,
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		$c->stash->{ paid_list_email }->paid_list_email_elements->delete;
		$c->stash->{ paid_list_email }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'paid_list_email deleted';
		
		# Redirect to the paid list's edit page
		my $uri = $c->uri_for( 'paid-list', $c->stash->{ paid_list }->id, 'edit' );
		$c->response->redirect( $uri );
		return;
	}
	
	# Extract email details from form
	my $details = {
		subject   => $c->request->param( 'subject'   ) || undef,
		delay     => $c->request->param( 'delay'     ) || 0,
		plaintext => $c->request->param( 'plaintext' ) || undef,
	};
	
	# Add in the template ID if one was passed in
	$details->{ template } = $c->request->param( 'template' ) 
		if $c->request->param( 'template' );
	
	# TODO: If template has changed, change element stack
	#if ( $c->request->param( 'template' ) != $c->stash->{ paid_list_email }->template->id ) {
		# Fetch old element set
		# Fetch new element set
		# Find the difference between the two sets
		# Add missing elements
		# Remove superfluous elements? Probably not - keep in case of reverts.
	#}
	
	# Extract email elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		if ( $input =~ m/^type_(\d+)$/ ) {
			# skip unless user is a template admin
			next unless $c->user->has_role( 'Newsletter Template Admin' );
			my $id = $1;
			$elements->{ $id }{ 'type'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	
	# Update paid list email
	my $paid_list_email = $c->stash->{ paid_list_email }->update( $details );
	
	# Update paid list email elements
	foreach my $element ( keys %$elements ) {
		$c->stash->{ paid_list_email }->paid_list_email_elements->find({
			id => $element,
		})->update( $elements->{ $element } );
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Details updated';
	
	# Bounce back to the 'edit' page
	my $uri = $c->uri_for( 
		'paid-list', $c->stash->{ paid_list }->id, 
		'email', $paid_list_email->id, 'edit'
	);
	$c->response->redirect( $uri );
}


=head2 preview_paid_email

Preview a paid list email.

=cut

sub preview_paid_email : Chained( 'get_paid_list_email' ) PathPart( 'preview' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to preview paid list emails
	return 0 unless $self->user_exists_and_can($c, {
		action => 'preview paid list emails', 
		role   => 'Newsletter Admin',
	});
	
	# Get the updated email details from the form
	my $new_details = {
		title => $c->request->param( 'subject' ) || 'No title given',
	};
	
	# Extract email elements from form
	my $elements = {};
	foreach my $input ( keys %{$c->request->params} ) {
		if ( $input =~ m/^name_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'name'    } = $c->request->param( $input );
		}
		elsif ( $input =~ m/^content_(\d+)$/ ) {
			my $id = $1;
			$elements->{ $id }{ 'content' } = $c->request->param( $input );
		}
	}
	# And set them up for insertion into the preview
	my $new_elements = {};
	foreach my $key ( keys %$elements ) {
		$new_elements->{ $elements->{ $key }->{ name } } = $elements->{ $key }->{ content };
	}
	
	# Stash site details
	$c->stash->{ site_name } = $c->config->{ site_name };
	$c->stash->{ site_url  } = $c->uri_for( '/' );
	
	# Stash recipient details
	$c->stash->{ recipient }->{ name  } = 'A. Person';
	$c->stash->{ recipient }->{ email } = 'a.person@example.com';
	
	# Set the TT template to use
	my $new_template;
	if ( $c->request->param( 'template' ) ) {
		$new_template = $c->model( 'DB::NewsletterTemplate' )->find({
			id => $c->request->param( 'template' )
		})->filename;
	}
	else {
		# Get template details from db
		$new_template = $c->stash->{ paid_list_email }->template->filename;
	}
	
	# Over-ride everything
	$c->stash->{ paid_list_email } = $new_details;
	$c->stash->{ elements } = $new_elements;
	$c->stash->{ template } = 'newsletters/newsletter-templates/'. $new_template;
	$c->stash->{ preview  } = 'preview';
}



# ========== ( Mailing Lists ) ==========

=head2 list_lists

View a list of all mailing lists.

=cut

sub list_lists : Chained( 'base' ) : PathPart( 'list-lists' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to make sure user has the right to view the list of mailing lists
	return 0 unless $self->user_exists_and_can($c, {
		action => 'view all mailing lists', 
		role   => 'Newsletter Admin',
	});
	
	# Fetch the list of mailing lists
	my @lists = $c->model( 'DB::MailingList' )->all;
	$c->stash->{ mailing_lists } = \@lists;
}


=head2 get_list

Stash details relating to a mailing list.

=cut

sub get_list : Chained( 'base' ) : PathPart( 'lists' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $list_id ) = @_;
	
	$c->stash->{ mailing_list } = $c->model( 'DB::MailingList' )->find({
		id => $list_id
	});
	
	unless ( $c->stash->{ mailing_list } ) {
		$c->flash->{ error_msg } = 
			'Specified mailing list not found - please select from the options below';
		$c->go( 'list_lists' );
	}
}


=head2 add_list

Add a new mailing list.

=cut

sub add_list : Chained( 'base' ) : PathPart( 'add-list' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add mailing lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a new mailing list', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	$c->stash->{ template } = 'admin/newsletters/edit_list.tt';
}


=head2 edit_list

Edit an existing mailing list.

=cut

sub edit_list : Chained( 'get_list' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit mailing lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit mailing lists', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
}


=head2 generate_email_token

Generate an email address token.

=cut

sub generate_email_token {
	my ( $self, $c, $email ) = @_;
	
	my $timestamp = DateTime->now->datetime;
	my $md5 = Digest::MD5->new;
	$md5->add( $email, $timestamp );
	my $code = $md5->hexdigest;
	
	return $code;
}


=head2 edit_list_do

Process a mailing list update or addition.

=cut

sub edit_list_do : Chained( 'base' ) : PathPart( 'edit-list-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit mailing lists
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit mailing lists', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	my $list_id = $c->request->param( 'list_id' );
	$c->stash->{ mailing_list } = $c->model( 'DB::MailingList' )->find({
		id => $list_id,
	});
	
	# Process deletions
	if ( defined $c->request->params->{ delete } && $c->request->param( 'delete' ) eq 'Delete' ) {
		# Find any newsletters using this list, and disconnect them
		my $newsletters = $c->model('DB::Newsletter')->search({
			list => $list_id,
		});
		$newsletters->update({
			list => undef,
		}) if $newsletters;
		
		# Find anyone marked as a recipient for this list and disconnect them
		my $recipients = $c->model('DB::ListRecipient')->search({
			list => $list_id,
		});
		$recipients->delete;
		
		$c->stash->{ mailing_list }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'List deleted';
		
		# Bounce to the default page
		$c->response->redirect( $c->uri_for( 'list-lists' ) );
		return;
	}
	
	my $sub   = 0; $sub   = 1 if $c->request->param( 'user_can_sub'   ) eq 'on';
	my $unsub = 0; $unsub = 1 if $c->request->param( 'user_can_unsub' ) eq 'on';
	if ( $c->request->param( 'list_id' ) ) {
		# Update existing list
		$c->stash->{ mailing_list }->update({
			name           => $c->request->param( 'name'           ),
			user_can_sub   => $sub,
			user_can_unsub => $unsub,
		});
		
		# Extract uploaded datafile, if any
		my $datafile = $c->request->upload( 'datafile' );
		if ( $datafile ) {
			my $parser = Text::CSV::Simple->new;	# comma-separated
			#my $parser = Text::CSV::Simple->new({ sep_char => "\t" });	# tab-separated
			my @data = $parser->read_file( $datafile->fh );
			if ( @data ) {
				# Wipe the existing recipient list
				$c->stash->{ mailing_list }->subscriptions->delete;
			}
			else {
				# Reading in the CSV file went wrong
				$c->log->warn( "Error reading CSV file: $!" );
			}
			foreach my $row ( @data ) {
				next unless $row->[1];
				my $email = $row->[1];
				my $token = $self->generate_email_token( $c, $email );
				my $recipient = $c->model('DB::MailRecipient')->update_or_create({
					email => $email,
					token => $token,
					name  => $row->[0],
				});
				$c->stash->{ mailing_list }->subscriptions->create({
					recipient => $recipient->id,
				});
			}
		}
	}
	else {
		# Create new list
		$c->stash->{ mailing_list } = $c->model( 'DB::MailingList' )->create({
			name           => $c->request->param( 'name' ),
			user_can_sub   => $sub,
			user_can_unsub => $unsub,
		});
	}
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'List details saved';
	
	# Bounce back to the edit page
	my $uri = $c->uri_for( 'lists', $c->stash->{ mailing_list }->id, 'edit' );
	$c->response->redirect( $uri );
}


=head2 subscribe

Subscribe someone to a mailing list.

=cut

sub subscribe : Chained( 'get_list' ) : PathPart( 'subscribe' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit mailing list subscribers
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit mailing list subscribers', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Create (or fetch and update) recipient record in database
	my $email = $c->request->param( 'email' );
	my $name  = $c->request->param( 'name'  );
	my $token = $self->generate_email_token( $c, $email );
	my $recipient = $c->model( 'DB::MailRecipient' )->update_or_create({
		email => $email,
		token => $token,
		name  => $name,
	});
	
	# Create a subscription to this list for this recipient
	$c->stash->{ mailing_list }->subscriptions->create({
		recipient => $recipient->id,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Subscription added';
	
	# Redirect to 'edit mailing list' page
	my $uri = $c->uri_for( 'lists', $c->stash->{ mailing_list }->id, 'edit' );
	$c->response->redirect( $uri );
}


=head2 unsubscribe

Unsubscribe someone from a mailing list.

=cut

sub unsubscribe : Chained( 'get_list' ) : PathPart( 'unsubscribe' ) : Args( 1 ) {
	my ( $self, $c, $subscription_id ) = @_;
	
	# Check to see if user is allowed to edit mailing list subscribers
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit mailing list subscribers', 
		role     => 'Newsletter Admin',
		redirect => $c->uri_for
	});
	
	# Find subscription and delete it
	my $subscription = $c->stash->{ mailing_list }->subscriptions->search({
		recipient => $subscription_id,
	})->first;
	$subscription->delete if $subscription;
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Subscription removed';
	
	# Redirect to 'edit mailing list' page
	my $uri = $c->uri_for( 'lists', $c->stash->{ mailing_list }->id, 'edit' );
	$c->response->redirect( $uri );
}



# ========== ( Templates ) ==========

=head2 list_templates

List all the newsletter templates.

=cut

sub list_templates : Chained( 'base' ) : PathPart( 'list-templates' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Bounce if user isn't logged in and a newsletter admin
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'list newsletter templates', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	my @templates = $c->model( 'DB::NewsletterTemplate' )->all;
	$c->stash->{ newsletter_templates } = \@templates;
}


=head2 get_template

Stash details relating to a CMS template.

=cut

sub get_template : Chained( 'base' ) : PathPart( 'template' ) : CaptureArgs( 1 ) {
	my ( $self, $c, $template_id ) = @_;
	
	$c->stash->{ newsletter_template } = $c->model( 'DB::NewsletterTemplate' )->find( { id => $template_id } );
	
	unless ( $c->stash->{ newsletter_template } ) {
		$c->flash->{ error_msg } = 
			'Specified template not found - please select from the options below';
		$c->go( 'list_templates' );
	}
	
	# Get template elements
	my @elements = $c->model( 'DB::NewsletterTemplateElement' )->search( {
		template => $c->stash->{ newsletter_template }->id,
	} );
	
	$c->stash->{ template_elements } = \@elements;
}


=head2 get_template_filenames

Get a list of available template filenames.

=cut

sub get_template_filenames {
	my ( $c ) = @_;
	
	my $template_dir = $c->path_to( 'root/newsletters/newsletter-templates' );
	opendir( my $template_dh, $template_dir ) 
		or die "Failed to open template directory $template_dir: $!";
	my @templates;
	foreach my $filename ( readdir( $template_dh ) ) {
		next if $filename =~ m/^\./; # skip hidden files
		next if $filename =~ m/~$/;  # skip backup files
		push @templates, $filename;
	}
	@templates = sort @templates;
	
	return \@templates;
}


=head2 add_template

Add a new newsletter template.

=cut

sub add_template : Chained( 'base' ) : PathPart( 'add-template' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add templates
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a new template', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	$c->stash->{ template_filenames } = get_template_filenames( $c );
	
	$c->stash->{ types  } = get_element_types();
	
	$c->stash->{ template } = 'admin/newsletters/edit_template.tt';
}


=head2 add_template_do

Process a template addition.

=cut

sub add_template_do : Chained( 'base' ) : PathPart( 'add-template-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add templates
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a new template', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	# Create template
	my $template = $c->model( 'DB::NewsletterTemplate' )->create({
		name     => $c->request->param( 'name'     ),
		filename => $c->request->param( 'filename' ),
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Template details saved';
	
	# Bounce back to the template list
	$c->response->redirect( $c->uri_for( 'list-templates' ) );
}


=head2 edit_template

Edit a CMS template.

=cut

sub edit_template : Chained( 'get_template' ) : PathPart( 'edit' ) : Args( 0 ) {
	my ( $self, $c, $template_id ) = @_;
	
	# Bounce if user isn't logged in and a newsletter admin
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a template', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	$c->stash->{ types  } = get_element_types();
	
	$c->stash->{ template_filenames } = get_template_filenames( $c );
}


=head2 edit_template_do

Process a template edit.

=cut

sub edit_template_do : Chained( 'base' ) : PathPart( 'edit-template-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to edit newsletter templates
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'edit a template', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	my $template_id = $c->request->param( 'template_id' );
	$c->stash->{ newsletter_template } = $c->model( 'DB::NewsletterTemplate' )->find({
		id => $template_id,
	});
	
	# Process deletions
	if ( $c->request->param( 'delete' ) eq 'Delete' ) {
		$c->stash->{ newsletter_template }->newsletter_template_elements->delete;
		$c->stash->{ newsletter_template }->delete;
		
		# Shove a confirmation message into the flash
		$c->flash->{ status_msg } = 'Template deleted';
		
		# Bounce to the 'view all templates' page
		$c->response->redirect( $c->uri_for( 'list-templates' ) );
		return;
	}
	
	# Update template
	$c->stash->{ newsletter_template }->update({
		name     => $c->request->param('name'    ),
		filename => $c->request->param('filename'),
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Template details updated';
	
	# Bounce back to the list of templates
	$c->response->redirect( $c->uri_for( 'list-templates' ) );
}


=head2 add_template_element_do

Add an element to a template.

=cut

sub add_template_element_do : Chained( 'get_template' ) : PathPart( 'add-template-element-do' ) : Args( 0 ) {
	my ( $self, $c ) = @_;
	
	# Check to see if user is allowed to add template elements
	return 0 unless $self->user_exists_and_can($c, {
		action   => 'add a new element to a newsletter template', 
		role     => 'Newsletter Template Admin',
		redirect => $c->uri_for
	});
	
	# Extract element from form
	my $element = $c->request->param( 'new_element' );
	my $type    = $c->request->param( 'new_type'    );
	
	# Update the database
	$c->model( 'DB::NewsletterTemplateElement' )->create({
		template => $c->stash->{ newsletter_template }->id,
		name     => $element,
		type     => $type,
	});
	
	# Shove a confirmation message into the flash
	$c->flash->{ status_msg } = 'Element added';
	
	# Bounce back to the 'edit' page
	$c->response->redirect( $c->uri_for( 'template', $c->stash->{ newsletter_template }->id, 'edit' ) );
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

