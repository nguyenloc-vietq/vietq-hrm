import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { SalaryPayrollListView } from 'src/sections/salary/view';

// ----------------------------------------------------------------------

const metadata = { title: `Salary list | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>

      <SalaryPayrollListView />
    </>
  );
}
