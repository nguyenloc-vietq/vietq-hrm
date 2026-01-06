import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

import { CreateShiftForm } from '../create-shift-form';

// ======================================================================

export function CreateShiftView() {
  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Create a new shift"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Schedule', href: paths.dashboard.schedule.root },
          { name: 'New shift' },
        ]}
        sx={{ mb: { xs: 3, md: 5 } }}
      />

      <CreateShiftForm />
    </DashboardContent>
  );
}
