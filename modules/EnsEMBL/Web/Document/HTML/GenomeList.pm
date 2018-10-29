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

package EnsEMBL::Web::Document::HTML::GenomeList;

use strict;
use warnings;

use JSON;
use HTML::Entities qw(encode_entities);

use parent qw(EnsEMBL::Web::Document::HTML);

use constant SPECIES_DISPLAY_LIMIT => 6;

## Begin GenomeHubs Modifications
sub _get_dom_tree {
  ## @private
  my ($self, $params) = @_;
  my $hub       = $self->hub;
  my $sd        = $hub->species_defs;
  my $group     = $params->{'group'};
  my $species_group = 'ASSEMBLY_GROUP_'.$group;
  my $title_field = $species_group.'_TITLE';
  my $template_field = $species_group.'_TEMPLATE';
  my $template_function = $sd->$template_field || '_fav_template';
  my $title     = $sd->$title_field || 'Choose an assembly to begin';
  my $species   = $self->_species_list({'no_user' => 1, 'group' => $group, 'species_group' => $species_group});
  my $template  = $self->can($template_function) ? $self->$template_function : $self->_fav_template;
  my $prehtml   = '';
  for (0..length($species)-1) {
    $prehtml .= $template =~ s/\{\{species\.(\w+)}\}/my $replacement = $species->[$_]{$1};/gre if $species->[$_];
  }
  if (!$prehtml){
    return $self->dom->create_element('span');
  }
  return $self->dom->create_element('div', {
    'class'     => 'static_favourite_species',
    'children'  => [{
      'node_name'  => 'h3',
      'class'      => 'lb-heading',
      'inner_HTML' => $title
    },{
      'node_name'  => 'div',
      'class'      => 'species_list_container species-list',
      'inner_HTML' => $prehtml
    }]
  });
}
## End GenomeHubs Modifications

sub add_species_dropdown { '<p><select class="fselect _all_species"><option value="">-- Select a species --</option></select></p>' }

sub species_list_url { return '/info/about/species.html'; }

## Begin GenomeHubs Modifications
sub _species_list {
  ## @private
  my ($self, $params) = @_;

  $params   ||= {};
  my $hub     = $self->hub;
  my $sd      = $hub->species_defs;
  my $species = $hub->get_species_info;
  my $user    = $params->{'no_user'} ? undef : $hub->users_plugin_available && $hub->user;
  my $img_url = $sd->img_url || '';

  my (@list, %done);
  warn $params->{'species_group'};
  my @set = @{$hub->get_species_set($params->{'species_group'})};
  if (scalar @set == 0 && $params->{'group'} eq 'A'){
    @set = @{$hub->get_favourite_species(!$user)};
  }
  foreach (@set) {
#  for (@fav, sort {$species->{$a}{'common'} cmp $species->{$b}{'common'}} keys %$species) {
    next if ($done{$_} || !$species->{$_} || !$species->{$_}{'is_reference'});
    $done{$_} = 1;

    my $homepage      = $hub->url({'species' => $_, 'type' => 'Info', 'function' => 'Index', '__clear' => 1});
    my $alt_assembly  = $sd->get_config($_, 'SWITCH_ASSEMBLY');
    my $strainspage   = $species->{$_}{'has_strains'} ? $hub->url({'species' => $_, 'type' => 'Info', 'function' => 'Strains', '__clear' => 1}) : 0;

    my $extra = $_ eq 'Homo_sapiens' ? '<a href="/info/website/tutorials/grch37.html" class="species-extra">Still using GRCh37?</a>' : '';

    push @list, {
      key         => $_,
      group       => $species->{$_}{'group'},
      homepage    => $homepage,
      name        => $species->{$_}{'name'},
      img         => sprintf('%sspecies/%s.png', $img_url, $_),
      common      => $species->{$_}{'common'},
      assembly    => $species->{$_}{'assembly'},
      assembly_v  => $species->{$_}{'assembly_version'},
      favourite   => 0,
      strainspage => $strainspage,
      has_alt     => $alt_assembly ? 1 : 0,
      extra       => $extra,
    };

  }
  return \@list;
}

sub _fav_template {
  ## @private
  return qq(
  <div class="lb-species-box">
    <div class="lb-sp-img">
      <a href="{{species.homepage}}"><img src="{{species.img}}" alt="{{species.name}}" title="Browse {{species.name}}" class="badge-48"/></a>
    </div>
    <a href="{{species.homepage}}" class="lb-primary-assembly">{{species.common}}</a>
    <div class="lb-alternate-assemblies">
      <a class="lb-alternate-assemblies" href="{{species.homepage}}">{{species.assembly}}</a>
    </div>
  </div>);
}

sub _list_template {
  ## @private
  return qq(
  <div class="lb-extra-species-box">
    <div class="lb-extra-sp-img">
      <a href="{{species.homepage}}"><img src="{{species.img}}" alt="{{species.name}}" title="Browse {{species.name}}"/></a>
    </div>
    <a href="{{species.homepage}}" class="lb-primary-assembly">{{species.common}} {{species.assembly}}</a>
  </div>);
}
## End GenomeHubs Modifications

1;
