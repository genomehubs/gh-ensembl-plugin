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

package EnsEMBL::Web::Document::Element::FooterLinks;

### Generates release info for the footer

use strict;

use base qw(EnsEMBL::Web::Document::Element);

sub content {
  my $species_defs = shift->species_defs;
## Begin GenomeHubs Modifications
  my $link = sprintf '<a href="%s">visit %s</a>', $species_defs->PROJECT_URL, $species_defs->PROJECT_URL_TITLE;
  my $issue = sprintf '<a href="%s">%s</a>', $species_defs->ISSUE_TRACKER_URL, $species_defs->ISSUE_TRACKER_TITLE;
  my $contact = sprintf '<a href="mailto:%s">contact us</a>', $species_defs->ENSEMBL_SERVERADMIN;
  return sprintf '<div class="column-two right"><p>%s release %s - %s<br/>%s | %s | %s</p></div>', $species_defs->ENSEMBL_SITE_NAME, $species_defs->SITE_RELEASE_VERSION, $species_defs->SITE_RELEASE_DATE, $link, $issue, $contact;
## End GenomeHubs Modifications
}

1;
