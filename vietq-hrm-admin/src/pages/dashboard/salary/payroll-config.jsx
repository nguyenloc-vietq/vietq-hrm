import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { PayrollConfigView } from 'src/sections/salary/view/salary-payroll-config-view';

// ----------------------------------------------------------------------

const metadata = { title: `Report salary | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <PayrollConfigView />
    </>
  );
}
