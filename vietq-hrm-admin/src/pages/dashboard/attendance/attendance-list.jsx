import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { AttendanceListRecords } from 'src/sections/attendance/view';

const metadata = { title: `attendance Records | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <AttendanceListRecords />
    </>
  );
}
