import { Helmet } from 'react-helmet-async';

import { NotificationTestView } from 'src/sections/notifications/view';

// ----------------------------------------------------------------------

export default function NotificationTestPage() {
  return (
    <>
      <Helmet>
        <title> Dashboard: Test Notification</title>
      </Helmet>

      <NotificationTestView />
    </>
  );
}
