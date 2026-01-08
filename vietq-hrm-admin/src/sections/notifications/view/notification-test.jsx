import React from 'react';
import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';
import { DashboardContent } from 'src/layouts/dashboard';
import { paths } from 'src/routes/paths';

export default function NotificationTestView() {
  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Notification Test"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Notification', href: paths.dashboard.registration.root },
          { name: 'Notification Test' },
        ]}
        sx={{ mb: { xs: 3, md: 5 } }}
      />
    </DashboardContent>
  );
}
