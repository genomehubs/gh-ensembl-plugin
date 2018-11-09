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

package EnsEMBL::Web::Component::Gene::Summary;

use strict;
use warnings;
no warnings 'uninitialized';

use HTML::Entities qw(encode_entities);

use base qw(EnsEMBL::Web::Component::Gene);

sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(0);
}

# status warnings/hints would be eg out-of-date page, dubious evidence, etc
# which need to be displayed prominently at the top of a page. Only used
# in Vega plugin at the moment, but probably more widely useful.
sub status_warnings { return undef; }
sub status_hints    { return undef; }

sub content {
  my $self = shift;
  my $object = $self->object;
  
  return sprintf '<p>%s</p>', encode_entities($object->Obj->description) if $object->Obj->isa('Bio::EnsEMBL::Compara::Family'); # Grab the description of the object
  return sprintf '<p>%s</p>', 'This identifier is not in the current EnsEMBL database' if $object->Obj->isa('Bio::EnsEMBL::ArchiveStableId');

  my $html = "";
 
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

## Begin GenomeHubs Modifications

  my $hub         = $self->hub;
  my $object      = $self->object;
  my $species     = $hub->species;
  my $table       = $self->new_twocol;
  my $gene        = $object->Obj;

  # add blast links
  my $title = $species.'__gene__'.$object->stable_id;
  my $slice = $object->slice;
  my $blast_html;
  $blast_html = $self->sequenceserver_button($title,'Gene');

  $table->add_row('BLAST',$blast_html);

  # add gene tree buttons
  my $member     = $object->database('compara') ? $object->database('compara')->get_GeneMemberAdaptor->fetch_by_stable_id($object->stable_id) : undef;
  my $gt_html;
  if ($member && $member->has_GeneTree){
    my $gene_tree_url = $hub->url({
      type   => 'Gene',
      action => 'Compara_Tree',
      g      => $gene->stable_id
    });
    $gt_html = $self->gene_tree_button($gene_tree_url,'Gene tree');
  }

  if ($gt_html){
    $table->add_row('Gene trees',$gt_html);
  }

  $html .= sprintf '<div class="summary_panel">%s</div>', $table->render;
## End GenomeHubs Modifications
  return $html;
}

1;
