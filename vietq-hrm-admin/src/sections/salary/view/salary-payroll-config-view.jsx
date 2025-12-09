import React from 'react';

import { Tab, Card, Tabs } from '@mui/material';

import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

export function PayrollConfigView() {
  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Payroll"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Salary', href: paths.dashboard.user.root },
          { name: 'Payroll Config' },
        ]}
        // action={
        //   <Button
        //     component={RouterLink}
        //     href={paths.dashboard.user.new}
        //     variant="contained"
        //     startIcon={<Iconify icon="mingcute:add-line" />}
        //   >
        //     New user
        //   </Button>
        // }
        sx={{ mb: { xs: 3, md: 5 } }}
      />
      <Card>
        <Tabs value={0} onChange={() => {}}>
          <Tab label="Payroll Config" />
        </Tabs>
      </Card>
    </DashboardContent>
  );
}
