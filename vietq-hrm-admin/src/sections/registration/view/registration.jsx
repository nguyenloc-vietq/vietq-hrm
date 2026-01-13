import { toast } from 'sonner';
import React, { useState, useEffect, useCallback } from 'react';

import { Box, Tab, Card, Tabs, Table, Tooltip, TableBody, IconButton } from '@mui/material';

import { paths } from 'src/routes/paths';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import { varAlpha } from 'src/theme/styles';
import { DashboardContent } from 'src/layouts/dashboard';
import RegistrationApi from 'src/services/api/registration.api';

import { Label } from 'src/components/label';
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

import { TableSkeleton } from 'src/sections/salary/payroll-table-row';
import { UserTableToolbar } from 'src/sections/user/user-table-toolbar';
import { UserTableFiltersResult } from 'src/sections/user/user-table-filters-result';

import { RegistrationTableRow } from '../registration-table-row';

const TABS = [
  { value: 'all', label: 'All' },
  { value: 'APPROVED', label: 'Approved' },
  { value: 'REJECTED', label: 'Rejected' },
  { value: 'PENDING', label: 'Pending' },
];

const TABLE_HEAD = [
  { id: 'userCode', label: 'User Code' },
  { id: 'type', label: 'Type' },
  { id: 'startDate', label: 'Start Date' },
  { id: 'endDate', label: 'End Date' },
  { id: 'reason', label: 'Reason' },
  { id: 'status', label: 'Status' },
  { id: 'actions', label: 'Actions', align: 'right' },
];

export function RegistrationMain() {
  const table = useTable({ defaultRowsPerPage: 10 });
  const confirm = useBoolean();
  const isLoading = useBoolean();

  const [tableData, setTableData] = useState([]);
  const [summaryData, setSummaryData] = useState({});

  const filters = useSetState({ name: '', role: [], status: 'all' });

  const fetchRegistrations = useCallback(async () => {
    try {
      isLoading.onTrue();
      const response = await RegistrationApi.getList();
      setTableData(response.items);
      setSummaryData(response.summary);
    } catch (error) {
      console.error(error);
      toast.error('Failed to fetch registrations');
    } finally {
      isLoading.onFalse();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    fetchRegistrations();
  }, [fetchRegistrations]);

  const dataFiltered = applyFilter({
    inputData: tableData,
    comparator: getComparator(table.order, table.orderBy),
    filters: filters.state,
  });

  const dataInPage = rowInPage(dataFiltered, table.page, table.rowsPerPage);
  const canReset = !!filters.state.name || filters.state.status !== 'all';
  const notFound = (!dataFiltered.length && canReset) || !dataFiltered.length;

  const handleFilterStatus = useCallback(
    (event, newValue) => {
      table.onResetPage();
      filters.setState({ status: newValue });
    },
    [filters, table]
  );

  const handleDeleteRow = useCallback(
    (id) => {
      // This should call an API to delete
      const deleteRow = tableData.filter((row) => row.id !== id);
      toast.success('Delete success!');
      setTableData(deleteRow);
      table.onUpdatePageDeleteRow(dataInPage.length);
    },
    [dataInPage.length, table, tableData]
  );

  const handleDeleteRows = useCallback(() => {
    // This should call an API to delete
    const deleteRows = tableData.filter((row) => !table.selected.includes(row.id));
    toast.success('Delete success!');
    setTableData(deleteRows);
    table.onUpdatePageDeleteRows({
      totalRowsInPage: dataInPage.length,
      totalRowsFiltered: dataFiltered.length,
    });
  }, [dataFiltered.length, dataInPage.length, table, tableData]);

  const handleApproveRow = useCallback(
    async (row) => {
      toast.loading('Loading...!');

      try {
        await RegistrationApi.approve({
          registrationCode: row,
          status: 'APPROVED',
        });
        toast.dismiss();
        toast.success('APPROVED successfully!');
        fetchRegistrations(); // refetch to get updated summary
      } catch (error) {
        toast.dismiss();
        toast.error('Failed to APPROVED registration');
      }
    },
    [fetchRegistrations]
  );

  const handleRejectRow = useCallback(
    async (row) => {
      toast.loading('Loading...!');
      try {
        await RegistrationApi.reject({
          registrationCode: row,
          status: 'REJECTED',
        });
        toast.dismiss();
        toast.success('Rejected successfully!');
        fetchRegistrations(); // refetch to get updated summary
      } catch (error) {
        toast.dismiss();
        toast.error('Failed to reject registration');
      }
    },
    [fetchRegistrations]
  );

  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Registration"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Registration', href: paths.dashboard.registration.root },
          { name: 'List' },
        ]}
        sx={{ mb: { xs: 3, md: 5 } }}
      />
      <Card>
        <Tabs
          value={filters.state.status}
          onChange={handleFilterStatus}
          sx={{
            px: 2.5,
            boxShadow: (theme) =>
              `inset 0 -2px 0 0 ${varAlpha(theme.vars.palette.grey['500Channel'], 0.08)}`,
          }}
        >
          {TABS.map((tab) => (
            <Tab
              key={tab.value}
              iconPosition="end"
              value={tab.value}
              label={tab.label}
              icon={
                <Label
                  variant={(tab.value === 'all' || tab.value === filters.state.status) && 'filled'}
                  color={
                    (tab.value === 'APPROVED' && 'success') ||
                    (tab.value === 'REJECTED' && 'error') ||
                    (tab.value === 'PENDING' && 'warning') ||
                    'default'
                  }
                >
                  {tab.value === 'all' && tableData.length}
                  {tab.value === 'APPROVED' && (summaryData.approved || 0)}
                  {tab.value === 'REJECTED' && (summaryData.rejected || 0)}
                  {tab.value === 'PENDING' && (summaryData.pending || 0)}
                </Label>
              }
            />
          ))}
        </Tabs>

        <UserTableToolbar
          filters={filters}
          isShowRole={false}
          onResetPage={table.onResetPage}
          options={{ roles: [] }}
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
                dataFiltered.map((row) => row.id)
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
            <Table size={table.dense ? 'small' : 'medium'} sx={{ minWidth: 960 }}>
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
                    dataFiltered.map((row) => row.id)
                  )
                }
              />
              {isLoading.value ? (
                <TableSkeleton length={TABLE_HEAD.length} />
              ) : (
                <TableBody>
                  {dataFiltered
                    .slice(
                      table.page * table.rowsPerPage,
                      table.page * table.rowsPerPage + table.rowsPerPage
                    )
                    .map((row) => (
                      <RegistrationTableRow
                        key={row.id}
                        row={row}
                        selected={table.selected.includes(row.id)}
                        onSelectRow={() => table.onSelectRow(row.id)}
                        onDeleteRow={() => handleDeleteRow(row.registrationCode)}
                        onApproveRow={() => handleApproveRow(row.registrationCode)}
                        onRejectRow={() => handleRejectRow(row.registrationCode)}
                      />
                    ))}
                  <TableEmptyRows
                    height={table.dense ? 56 : 56 + 20}
                    emptyRows={emptyRows(table.page, table.rowsPerPage, dataFiltered.length)}
                  />
                  <TableNoData notFound={notFound} />
                </TableBody>
              )}
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
    </DashboardContent>
  );
}

function applyFilter({ inputData, comparator, filters }) {
  const { name, status } = filters;

  const stabilizedThis = inputData.map((el, index) => [el, index]);

  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) return order;
    return a[1] - b[1];
  });

  inputData = stabilizedThis.map((el) => el[0]);

  if (name) {
    inputData = inputData.filter(
      (record) => record.userCode?.toLowerCase().indexOf(name.toLowerCase()) !== -1
    );
  }

  if (status !== 'all') {
    inputData = inputData.filter((record) => record.status === status);
  }

  return inputData;
}
