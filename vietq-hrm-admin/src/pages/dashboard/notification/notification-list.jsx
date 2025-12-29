import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { NotificationList } from 'src/sections/notifications/view';

const metadata = { title: `Registration | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <NotificationList />
    </>
  );
}
