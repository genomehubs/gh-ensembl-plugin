=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2018] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

=head1 MODIFICATIONS

Copyright [2018] University of Edinburgh

All modifications licensed under the Apache License, Version 2.0, as above.

=cut

package EnsEMBL::Web::Component::Transcript::Summary;

use strict;
use warnings;
no warnings 'uninitialized';

use base qw(EnsEMBL::Web::Component::Transcript);

sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(0);
}

# status warnings would be eg out-of-date page, dubious evidence, etc
# which need to be displayed prominently at the top of a page. Only used
# in Vega plugin at the moment, but probably more widely useful.
sub status_warnings { return undef; }
sub status_hints    { return undef; }

sub content {
  my $self = shift;
  my $object = $self->object;

  return sprintf '<p>%s</p>', $object->Obj->description if $object->Obj->isa('EnsEMBL::Web::Fake');

  my $html = "";
 
  if ($object->Obj->isa('Bio::EnsEMBL::Transcript')) {

    my @warnings = $self->status_warnings;
    if(@warnings>1 and $warnings[0] and $warnings[1]) {
      $html .= $self->_info_panel($warnings[2]||'warning',
                                $warnings[0],$warnings[1]);
    }
    my @hints = $self->status_hints;
    if(@hints>1 and $hints[0] and $hints[1]) {
      $html .= $self->_hint($hints[2],$hints[0],$hints[1]);
    }
    $html .= $self->transcript_table;
  }
  else {
    my ($function, $text);
    if ($self->hub->action =~ /Prot|Domain/) {
      $function = 'Protein';
      $text     = 'Protein';
    }
    else {
      $text     = 'Transcript';
    }
    my $url = $self->hub->url({'action' => 'Idhistory', 'function' => $function});
    $html = sprintf '<p>This transcript is not in the current gene set. Previous versions of the %s may be available on the <a href="%s">%s History page</a>.</p>', lc($text), $url, $text; 
  }

## Begin GenomeHubs Modifications

  my $hub         = $self->hub;
  my $object      = $self->object;
  my $species     = $hub->species;
  my $table       = $self->new_twocol;
  my $gene        = $object->gene;

  # add blast links
  my $title = $object->stable_id;
  my $slice = $object->slice;
  my $blast_html;
	my $transcripts = $gene->get_all_Transcripts;
	my $index = 0;
  if (@$transcripts > 1){
  	for (my $i = 0; $i < @$transcripts; $i++) {
  		$index = $i;
  		last if $title eq $transcripts->[$i]->stable_id;
  	}
  }
  my $seq = $transcripts->[$index]->seq()->seq();
  $blast_html = $self->sequenceserver_button($title,$seq,'Transcript');
  $seq = undef;
  $seq = $transcripts->[$index]->spliced_seq();
  $blast_html .= $self->sequenceserver_button($title,$seq,'cDNA') if $seq;
  $seq = undef;
  $seq = $transcripts->[$index]->translateable_seq();
  $blast_html .= $self->sequenceserver_button($title,$seq,'CDS') if $seq;
  $seq = undef;
  $seq = $transcripts->[$index]->translate()->seq();
  $blast_html .= $self->sequenceserver_button($transcripts->[$index]->stable_id,$seq,'Protein') if $seq;
  $table->add_row('BLAST',$blast_html);

  $html .= sprintf '<div class="summary_panel">%s</div>', $table->render;

## End GenomeHubs Modifications

  return $html;
}

1;
