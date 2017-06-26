=pod

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

=head1 NAME

BigFileParser - a parser for indexed files such as BigBed and BigWig 

=cut

package Bio::EnsEMBL::IO::BigFileParser;



=head2 open_file

    Description: Opens a remote file from URL
    Returntype : Filehandle 

=cut

sub open_file {
  my $self = shift;

  Bio::DB::BigFile->set_udc_defaults;
  
  my $method = $self->type.'FileOpen';

# GenomeHubs hack to get around problem opening files from URLs
# assumes trackhub directory has been mounted directly
  my $location = $self->{'url'};
  $location =~ s/^.+:\/\/.+trackhub/\/trackhub/ if (-d '/trackhub');
  $self->{cache}->{file_handle} ||= Bio::DB::BigFile->$method($location);
# End GenomeHubs hack
  return $self->{cache}->{file_handle};
}


1;
