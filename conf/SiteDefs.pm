package EG::GenomeHubs::SiteDefs;

use strict;


sub update_conf {
  push @$SiteDefs::ENSEMBL_API_LIBS, $SiteDefs::ENSEMBL_SERVERROOT . '/gh-ensembl-plugin/modules';

  $SiteDefs::SITE_LOGO = 'ensembl.genomehubs.png';
  $SiteDefs::SITE_LOGO_WIDTH = 150;
  $SiteDefs::SITE_LOGO_HEIGHT = 50;
  $SiteDefs::SITE_LOGO_ALT = 'GenomeHubs Ensembl';
  $SiteDefs::SITE_NAME = 'GenomeHubs Ensembl';

  $SiteDefs::ISSUE_TRACKER_URL = 'https://github.com/genomehubs/genomehubs/issues?status=new&status=open';
  $SiteDefs::ISSUE_TRACKER_TITLE = 'report an issue';

  $SiteDefs::ENSEMBL_SERVERADMIN = 'contact&#064;lepbase.org';

#  $SiteDefs::ASSEMBLY_GROUP_A = ['Melitaea_cinxia'];
  $SiteDefs::ASSEMBLY_GROUP_A_TITLE = 'Assemblies with gene models';
  $SiteDefs::ASSEMBLY_GROUP_A_TEMPLATE = '_fav_template';
#  $SiteDefs::ASSEMBLY_GROUP_B = ['Bombyx_mori'];
  $SiteDefs::ASSEMBLY_GROUP_B_TITLE = 'Assembly only';
  $SiteDefs::ASSEMBLY_GROUP_B_TEMPLATE = '_list_template';
  $SiteDefs::ASSEMBLY_GROUP_C_TITLE = 'Other Assemblies';
  $SiteDefs::ASSEMBLY_GROUP_C_TEMPLATE = '_list_template';
}


1;
