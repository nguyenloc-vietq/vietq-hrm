import React, { useState, useCallback } from 'react';

import { Box, Card, Table, Button, Tooltip, TableBody, IconButton } from '@mui/material';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import { _roles } from 'src/_mock';
import { DashboardContent } from 'src/layouts/dashboard';

import { toast } from 'src/components/snackbar';
import { Iconify } from 'src/components/iconify';
import { Scrollbar } from 'src/components/scrollbar';
import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';
import {
  useTable,
  emptyRows,
  rowInPage,
  TableNoData,
  getComparator,
  TableEmptyRows,
  TableHeadCustom,
  TableSelectedAction,
  TablePaginationCustom,
} from 'src/components/table';

import { UserTableToolbar } from 'src/sections/user/user-table-toolbar';
import { UserTableFiltersResult } from 'src/sections/user/user-table-filters-result';

import { PayrollTableRow } from '../payroll-table-row';
import CreateReportForm from '../payroll-create-report';

const TABLE_HEAD = [
  { id: 'payrollCode', label: 'Payroll Code', width: 200 },
  { id: 'payrollName', label: 'Payroll Name', width: 200 },
  { id: 'companyCode', label: 'Company Code', width: 200 },
  { id: 'startDate', label: 'Start Date', width: 100 },
  { id: 'endDate', label: 'End Date', width: 100 },
  { id: 'paymentDate', label: 'Payment Date', width: 100 },
  { id: 'isLocked', label: 'Is Locked', width: 100 },
  { id: 'isActive', label: 'Is Active', width: 100 },
  { id: 'createdAt', label: 'Created At', width: 100 },
  { id: 'updatedAt', label: 'Updated At', width: 100 },
  { id: 'actions', label: 'Actions', width: 100 },
];

export function SalaryReportView() {
  const router = useRouter();
  const openModal = useBoolean();
  const confirm = useBoolean();

  const table = useTable({ defaultRowsPerPage: 5 });

  const [tableData, setTableData] = useState([]);
  const filters = useSetState({ name: '', role: [], status: 'all' });

  const dataFiltered = applyFilter({
    inputData: tableData,
    comparator: getComparator(table.order, table.orderBy),
    filters: filters.state,
  });

  const dataInPage = rowInPage(dataFiltered, table.page, table.rowsPerPage);

  const canReset =
    !!filters.state.name || filters.state.role.length > 0 || filters.state.status !== 'all';

  const notFound = !dataFiltered.length;

  const handleDeleteRow = useCallback(
    (payrollCode) => {
      const newData = tableData.filter((row) => row.payrollCode !== payrollCode);

      toast.success('Delete success!');
      setTableData(newData);

      table.onUpdatePageDeleteRow(dataInPage.length);
    },
    [dataInPage.length, table, tableData]
  );

  const handleDeleteRows = useCallback(() => {
    const newData = tableData.filter((row) => !table.selected.includes(row.payrollCode));

    toast.success('Delete success!');
    setTableData(newData);

    table.onUpdatePageDeleteRows({
      totalRowsInPage: dataInPage.length,
      totalRowsFiltered: dataFiltered.length,
    });
  }, [dataFiltered.length, dataInPage.length, table, tableData]);

  const handleEditRow = useCallback(
    (payrollCode) => {
      router.push(paths.dashboard.payroll.edit(payrollCode));
    },
    [router]
  );

  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Payroll"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Salary', href: paths.dashboard.user.root },
          { name: 'Report' },
        ]}
        action={
          <Button
            onClick={openModal.onTrue}
            variant="contained"
            startIcon={<Iconify icon="mingcute:add-line" />}
          >
            New Report
          </Button>
        }
        sx={{ mb: { xs: 3, md: 5 } }}
      />

      <Card>
        <UserTableToolbar
          filters={filters}
          isShowRole={false}
          onResetPage={table.onResetPage}
          options={{ roles: _roles }}
        />

        {canReset && (
          <UserTableFiltersResult
            filters={filters}
            totalResults={dataFiltered.length}
            onResetPage={table.onResetPage}
            sx={{ p: 2.5, pt: 0 }}
          />
        )}

        <Box sx={{ position: 'relative' }}>
          <TableSelectedAction
            dense={table.dense}
            numSelected={table.selected.length}
            rowCount={dataFiltered.length}
            onSelectAllRows={(checked) =>
              table.onSelectAllRows(
                checked,
                dataFiltered.map((row) => row.payrollCode)
              )
            }
            action={
              <Tooltip title="Delete">
                <IconButton color="primary" onClick={confirm.onTrue}>
                  <Iconify icon="solar:trash-bin-trash-bold" />
                </IconButton>
              </Tooltip>
            }
          />

          <Scrollbar>
            <Table size={table.dense ? 'small' : 'medium'}>
              <TableHeadCustom
                order={table.order}
                orderBy={table.orderBy}
                headLabel={TABLE_HEAD}
                rowCount={dataFiltered.length}
                numSelected={table.selected.length}
                onSort={table.onSort}
                onSelectAllRows={(checked) =>
                  table.onSelectAllRows(
                    checked,
                    dataFiltered.map((row) => row.payrollCode)
                  )
                }
              />

              <TableBody>
                {dataInPage.map((row) => (
                  <PayrollTableRow
                    key={row.payrollCode}
                    row={row}
                    selected={table.selected.includes(row.payrollCode)}
                    onSelectRow={() => table.onSelectRow(row.payrollCode)}
                    onDeleteRow={() => handleDeleteRow(row.payrollCode)}
                    onEditRow={() => handleEditRow(row.payrollCode)}
                  />
                ))}

                <TableEmptyRows
                  height={table.dense ? 56 : 76}
                  emptyRows={emptyRows(table.page, table.rowsPerPage, dataFiltered.length)}
                />

                <TableNoData notFound={notFound} />
              </TableBody>
            </Table>
          </Scrollbar>
        </Box>

        <TablePaginationCustom
          page={table.page}
          dense={table.dense}
          count={dataFiltered.length}
          rowsPerPage={table.rowsPerPage}
          onPageChange={table.onChangePage}
          onChangeDense={table.onChangeDense}
          onRowsPerPageChange={table.onChangeRowsPerPage}
        />
      </Card>

      <CreateReportForm open={openModal.value} handleClose={openModal.onFalse} />
    </DashboardContent>
  );
}
function applyFilter({ inputData, comparator, filters }) {
  const { fullName, status, role } = filters;

  const stabilizedThis = inputData.map((el, index) => [el, index]);

  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) return order;
    return a[1] - b[1];
  });

  inputData = stabilizedThis.map((el) => el[0]);

  if (fullName) {
    inputData = inputData.filter(
      (user) => user.user.fullName.toLowerCase().indexOf(fullName.toLowerCase()) !== -1
    );
  }

  if (status !== 'all') {
    inputData = inputData.filter((user) => user.isActive === status);
  }

  if (role.length) {
    inputData = inputData.filter((user) => role.includes(user.role));
  }

  return inputData;
}
