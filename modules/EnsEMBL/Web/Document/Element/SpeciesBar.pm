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

package EnsEMBL::Web::Document::Element::SpeciesBar;

# Generates the global context navigation menu, used in dynamic pages

use strict;

use HTML::Entities qw(encode_entities);

use EnsEMBL::Web::Utils::FormatText qw(glossary_helptip);

use base qw(EnsEMBL::Web::Document::Element);

## BEGIN GENOMEHUBS MODIFICATIONS..

sub species_list {
  my $self = shift;

  my $hub           = $self->hub;
  my $species_info  = $hub->get_species_info;

  my (@ok_faves, %check_faves);

  foreach (@{$hub->get_favourite_species}) {
    push @ok_faves, [$species_info->{$_}->{'url'},$species_info->{$_}->{'scientific'}] unless $check_faves{$species_info->{$_}->{'scientific'}}++;
  }
  my $html;
  foreach my $sp (@ok_faves) {
    $html .= qq{<li><a class="constant" href="$sp->[0]">$sp->[1]</a></li>};
  }

  return qq{<div class="dropdown species"><h4>Select a species</h4><ul>$html</ul></div>};
}
## ..END GENOMEHUBS MODIFICATIONS

1;
