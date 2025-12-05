import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { SalaryConfigVew } from 'src/sections/salary/view/salary-config-view';

// ----------------------------------------------------------------------

const metadata = { title: `Salary Config | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>

      <SalaryConfigVew/>
    </>
  );
}
