import dayjs from 'dayjs';
import { toast } from 'sonner';
import React, { useState, useEffect, useCallback } from 'react';

import { Box, Tab, Card, Tabs, Table, Tooltip, TableBody, IconButton } from '@mui/material';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import { varAlpha } from 'src/theme/styles';
import { DashboardContent } from 'src/layouts/dashboard';
import { _roles, ACTIVE_STATUS_OPTION } from 'src/_mock';
import NotificationApi from 'src/services/api/notification.api';

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

import { NotificationListTableRow } from '../notifiaction-list-table-row';

const STATUS_OPTIONS = [{ value: 'all', label: 'All' }, ...ACTIVE_STATUS_OPTION];

const TABLE_HEAD = [
  { id: 'notificationCode', label: 'Notification Code', width: 120 },
  { id: 'notificationType', label: 'Notification Type', width: 120 },
  { id: 'title', label: 'Title', width: 180 },
  { id: 'body', label: 'Body', width: 100 },
  { id: 'targetType', label: 'Target Type', width: 100 },
  { id: 'targetValue', label: 'Target Value', width: 100 },
  { id: 'typeSystem', label: 'Type System', width: 120 },
  { id: 'scheduleTime', label: 'Schedule Time', width: 100 },
  { id: 'openSent', label: 'Open Sent', width: 140 },
  { id: 'isSent', label: 'Is Sent', width: 100 },
  { id: 'action', label: 'Action', width: 100 },
];

export const NotificationList = () => {
  const table = useTable({ defaultRowsPerPage: 12 });

  const router = useRouter();
  const isCreate = useBoolean();
  const confirm = useBoolean();
  const isLoading = useBoolean();
  const [tableData, setTableData] = useState([]);

  const [startDate, setStartDate] = useState(dayjs());
  const [endDate, setEndDate] = useState(dayjs().add(7, 'day'));
  const [isError, setIsError] = useState(false);
  const isOpenDialog = useBoolean();
  useEffect(() => {
    fetchListNotification();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  const handleStartChange = (newStart) => {
    setStartDate(newStart);
    if (endDate && newStart.isAfter(endDate, 'day')) {
      setIsError(true);
    } else {
      setIsError(false);
    }
  };

  const handleEndChange = (newEnd) => {
    setEndDate(newEnd);
    if (startDate && newEnd.isBefore(startDate, 'day')) {
      setIsError(true);
    } else {
      setIsError(false);
    }
  };

  console.log('[==================>', table.rowsPerPage);
  const fetchListNotification = async () => {
    try {
      isLoading.onTrue();
      const ListNotification = await NotificationApi.getAdminListNotification();
      console.log(`[===============> List Notification | `, ListNotification);
      setTableData(ListNotification);
    } catch (error) {
      console.log(error);
    } finally {
      isLoading.onFalse();
    }
  };
  const fetchListNotificationByMonth = async () => {
    try {
      isLoading.onTrue();

      const ListNotification = await NotificationApi.getAdminListNotification(startDate, endDate);
      console.log(`[===============> List Notification | `, ListNotification);
      setTableData(ListNotification);
      isOpenDialog.onFalse();
    } catch (error) {
      console.log(error);
    } finally {
      isLoading.onFalse();
    }
  };

  const filters = useSetState({ name: '', role: [], status: 'all' });

  const dataFiltered = applyFilter({
    inputData: tableData,
    comparator: getComparator(table.order, table.orderBy),
    filters: filters.state,
  });

  const dataInPage = rowInPage(dataFiltered, table.page, table.rowsPerPage);

  const canReset =
    !!filters.state.name || filters.state.role.length > 0 || filters.state.status !== 'all';

  const notFound = (!dataFiltered.length && canReset) || !dataFiltered.length;

  const handleDeleteRow = useCallback(
    (id) => {
      const deleteRow = tableData.filter((row) => row.id !== id);

      toast.success('Delete success!');

      setTableData(deleteRow);

      table.onUpdatePageDeleteRow(dataInPage.length);
    },
    [dataInPage.length, table, tableData]
  );

  const handleDeleteRows = useCallback(() => {
    const deleteRows = tableData.filter((row) => !table.selected.includes(row.id));

    toast.success('Delete success!');

    setTableData(deleteRows);

    table.onUpdatePageDeleteRows({
      totalRowsInPage: dataInPage.length,
      totalRowsFiltered: dataFiltered.length,
    });
  }, [dataFiltered.length, dataInPage.length, table, tableData]);

  const onUpdateRow = useCallback(
    (data) => {
      const updateRow = tableData.map((row) => {
        if (row.id === data.id) {
          return {
            ...row,
            ...data,
          };
        }
        return row;
      });
      setTableData(updateRow);
    },
    [tableData]
  );

  const handleEditRow = useCallback(
    (id) => {
      router.push(paths.dashboard.Notification.edit(id));
    },
    [router]
  );

  const handleFilterStatus = useCallback(
    (event, newValue) => {
      table.onResetPage();
      console.log(`[===============> filter | `, filters);
      filters.setState({ status: newValue });
    },
    [filters, table]
  );

  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Notification List"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Notification', href: paths.dashboard.registration.root },
          { name: 'Notification List' },
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
          {STATUS_OPTIONS.map((tab) => (
            <Tab
              key={tab.value}
              iconPosition="end"
              value={tab.value}
              label={tab.label}
              icon={
                <Label
                  variant={
                    ((tab.value === 'all' || tab.value === filters.state.status) && 'filled') ||
                    'soft'
                  }
                  color={
                    (tab.value === 'Y' && 'success') || (tab.value === 'N' && 'error') || 'default'
                  }
                >
                  {['Y', 'N'].includes(tab.value)
                    ? tableData.filter((user) => user.isActive === tab.value).length
                    : tableData.length}
                </Label>
              }
            />
          ))}
        </Tabs>

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
                <TableSkeleton length={TABLE_HEAD.length + 1} />
              ) : (
                <TableBody>
                  {dataFiltered
                    .slice(
                      table.page * table.rowsPerPage,
                      table.page * table.rowsPerPage + table.rowsPerPage
                    )
                    .map((row) => (
                      <NotificationListTableRow
                        key={row.id}
                        row={row}
                        selected={table.selected.includes(row.id)}
                        onUpdateRow={onUpdateRow}
                        onSelectRow={() => table.onSelectRow(row.id)}
                        onDeleteRow={() => handleDeleteRow(row.id)}
                        onEditRow={() => handleEditRow(row.id)}
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
};

function applyFilter({ inputData, comparator, filters }) {
  const { name, status, role } = filters;

  const stabilizedThis = inputData.map((el, index) => [el, index]);

  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) return order;
    return a[1] - b[1];
  });

  inputData = stabilizedThis.map((el) => el[0]);

  if (name) {
    inputData = inputData.filter(
      (record) =>
        record.employeeName?.toLowerCase().indexOf(name.toLowerCase()) !== -1 ||
        record.employeeCode?.toLowerCase().indexOf(name.toLowerCase()) !== -1
    );
  }

  if (status !== 'all') {
    inputData = inputData.filter((record) => record.isActive === status);
  }

  if (role.length) {
    inputData = inputData.filter((record) => role.includes(record.role));
  }

  return inputData;
}
