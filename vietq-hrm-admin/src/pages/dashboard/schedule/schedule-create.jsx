import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { ScheduleCreate } from 'src/sections/schedule/view';

const metadata = { title: `Schedule Create | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <ScheduleCreate />
    </>
  );
}
