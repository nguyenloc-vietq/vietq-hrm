import { Helmet } from 'react-helmet-async';
import { NotificationCreateView } from 'src/sections/notifications/view';

// ----------------------------------------------------------------------

export default function NotificationCreatePage() {
  return (
    <>
      <Helmet>
        <title> Dashboard: Create a new notification</title>
      </Helmet>

      <NotificationCreateView />
    </>
  );
}
