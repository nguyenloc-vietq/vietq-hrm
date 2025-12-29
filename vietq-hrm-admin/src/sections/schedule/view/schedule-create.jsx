import React from 'react';

import { Box } from '@mui/material';

import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

export const ScheduleCreate = () => (
  <DashboardContent>
    <CustomBreadcrumbs
      heading="Schedule Create"
      links={[
        { name: 'Dashboard', href: paths.dashboard.root },
        { name: 'Schedule', href: paths.dashboard.schedule.root },
        { name: 'Schedule Create' },
      ]}
      sx={{ mb: { xs: 3, md: 5 } }}
    />
    <Box>Schedule Create</Box>
  </DashboardContent>
);
