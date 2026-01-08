import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import NotificationTestView from 'src/sections/notifications/view/notification-test';

const metadata = { title: `Notification | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <NotificationTestView />
    </>
  );
}
