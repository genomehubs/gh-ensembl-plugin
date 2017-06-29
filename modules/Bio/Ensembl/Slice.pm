=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2017] EMBL-European Bioinformatics Institute

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


=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

  Questions may also be sent to the Ensembl help desk at
  <http://www.ensembl.org/Help/Contact>.

=cut

=head1 NAME

Bio::EnsEMBL::Slice - Arbitary Slice of a genome

=head1 SYNOPSIS

  $sa = $db->get_SliceAdaptor;

  $slice =
    $sa->fetch_by_region( 'chromosome', 'X', 1_000_000, 2_000_000 );

  # get some attributes of the slice
  my $seqname = $slice->seq_region_name();
  my $start   = $slice->start();
  my $end     = $slice->end();

  # get the sequence from the slice
  my $seq = $slice->seq();

  # get some features from the slice
  foreach $gene ( @{ $slice->get_all_Genes } ) {
    # do something with a gene
  }

  foreach my $feature ( @{ $slice->get_all_DnaAlignFeatures } ) {
    # do something with dna-dna alignments
  }

=head1 DESCRIPTION

A Slice object represents a region of a genome.  It can be used to retrieve
sequence or features from an area of interest.

NOTE: The Slice is defined by its Strand, but normal behaviour for get_all_*
methods is to return Features on both Strands.

=head1 METHODS

=cut

package Bio::EnsEMBL::Slice;
use vars qw(@ISA);
use strict;

use Bio::PrimarySeqI;


use Bio::EnsEMBL::Utils::Argument qw(rearrange);
use Bio::EnsEMBL::Utils::Exception qw(throw deprecate warning stack_trace_dump);
use Bio::EnsEMBL::RepeatMaskedSlice;
use Bio::EnsEMBL::Utils::Sequence qw(reverse_comp);
use Bio::EnsEMBL::ProjectionSegment;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Utils::Iterator;
use Bio::EnsEMBL::DBSQL::MergedAdaptor;

use Bio::EnsEMBL::StrainSlice;
#use Bio::EnsEMBL::IndividualSlice;
#use Bio::EnsEMBL::IndividualSliceFactory;
use Bio::EnsEMBL::Mapper::RangeRegistry;
use Bio::EnsEMBL::SeqRegionSynonym;
use Scalar::Util qw(weaken isweak);

# use Data::Dumper;

my $registry = "Bio::EnsEMBL::Registry";

@ISA = qw(Bio::PrimarySeqI);

=head2 get_all_synonyms

  Args [1]   : String external_db_name The name of the database to retrieve
               the synonym for
  Args [2]   : (optional) Integer external_db_version Optionally restrict
               results from external_db_name to a specific version of
               the the specified external database
  Example    : my @alternative_names = @{$slice->get_all_synonyms()};
               @alternative_names = @{$slice->get_all_synonyms('EMBL')};
  Description: get a list of alternative names for this slice
  Returntype : reference to list of SeqRegionSynonym objects.
  Exception  : none
  Caller     : general
  Status     : At Risk

=cut

sub get_all_synonyms {
  my ($self, $external_db_name, $external_db_version) = @_;

  if ( !defined( $self->{'synonym'} ) ) {
    my $adap = $self->adaptor->db->get_SeqRegionSynonymAdaptor();
    $self->{'synonym'} =
      $adap->get_synonyms( $self->get_seq_region_id($self) );
  }

#  if(! $external_db_name) {
    return $self->{'synonym'};
#  }
#  my @args =  ($external_db_version) ?
#              ($external_db_name, $external_db_version) :
#              ($external_db_name, undef, 1);
#  my $external_db_id = $self->adaptor->db()->get_DBEntryAdaptor()->get_external_db_id(@args);
#  if(!$external_db_id) {
#    my $extra = ($external_db_version) ? "and version $external_db_version " : q{};
#    throw "The external database $external_db_name ${extra}did not result in a valid identifier";
#  }
#
#  return [ grep { $_->external_db_id() == $external_db_id } @{$self->{synonym}} ];
}
