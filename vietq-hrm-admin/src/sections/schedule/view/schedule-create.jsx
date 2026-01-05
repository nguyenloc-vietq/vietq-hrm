import dayjs from 'dayjs';
import React, { useState, useEffect, useCallback } from 'react';

import {
  Box,
  Card,
  Table,
  Button,
  Tooltip,
  TableBody,
  IconButton,
  Typography,
} from '@mui/material';

import { paths } from 'src/routes/paths';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import ScheduleApi from 'src/services/api/schedule.api';
import { DashboardContent } from 'src/layouts/dashboard';

import { Iconify } from 'src/components/iconify';
import { Scrollbar } from 'src/components/scrollbar';
import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';
import { CustomDateRangePicker } from 'src/components/custom-date-range-picker';
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

import { ScheduleDetailDialog } from '../schedule-detail-dialog';
import { ScheduleCreateDialog } from '../schedule-create-dialog';
import { TableSkeleton, ScheduleListTableRow } from '../schedule-list-table-row';

const TABLE_HEAD = [
  { id: 'user', label: 'Employee', width: 220 },
  { id: 'email', label: 'Email', width: 200 },
  { id: 'totalSchedules', label: 'Total Schedules', width: 120 },
  { id: 'schedules', label: 'Schedules', width: 200 },
  { id: 'action', label: 'Action', width: 80 },
];

export const ScheduleCreate = () => {
  const table = useTable({ defaultRowsPerPage: 12 });
  const confirm = useBoolean();
  const isLoading = useBoolean();
  const isOpenDatePicker = useBoolean();
  const isOpenDetail = useBoolean();
  const isOpenCreate = useBoolean();

  const [tableData, setTableData] = useState([]);
  const [selectedRow, setSelectedRow] = useState(null);
  const [startDate, setStartDate] = useState(dayjs());
  const [endDate, setEndDate] = useState(dayjs().add(7, 'day'));
  const [isDateError, setIsDateError] = useState(false);

  useEffect(() => {
    fetchListSchedules();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const fetchListSchedules = async (start, end) => {
    try {
      isLoading.onTrue();
      const response = await ScheduleApi.getAdminListSchedules(
        start?.format('YYYY-MM-DD'),
        end?.format('YYYY-MM-DD')
      );
      setTableData(response?.data || []);
      if (response?.startDate) setStartDate(dayjs(response.startDate));
      if (response?.endDate) setEndDate(dayjs(response.endDate));
    } catch (error) {
      console.log(error);
    } finally {
      isLoading.onFalse();
    }
  };

  const handleStartChange = (newStart) => {
    setStartDate(newStart);
    if (endDate && newStart.isAfter(endDate, 'day')) {
      setIsDateError(true);
    } else {
      setIsDateError(false);
    }
  };

  const handleEndChange = (newEnd) => {
    setEndDate(newEnd);
    if (startDate && newEnd.isBefore(startDate, 'day')) {
      setIsDateError(true);
    } else {
      setIsDateError(false);
    }
  };

  const handleApplyDateFilter = () => {
    fetchListSchedules(startDate, endDate);
    isOpenDatePicker.onFalse();
  };

  const handleViewDetail = useCallback(
    (row) => {
      setSelectedRow(row);
      isOpenDetail.onTrue();
    },
    [isOpenDetail]
  );

  const handleCloseDetail = () => {
    setSelectedRow(null);
    isOpenDetail.onFalse();
  };

  const handleCreateSuccess = () => {
    fetchListSchedules(startDate, endDate);
  };

  const filters = useSetState({ name: '', role: [], status: 'all' });

  const dataFiltered = applyFilter({
    inputData: tableData,
    comparator: getComparator(table.order, table.orderBy),
    filters: filters.state,
  });

  const dataInPage = rowInPage(dataFiltered, table.page, table.rowsPerPage);

  const canReset = !!filters.state.name || filters.state.role.length > 0;

  const notFound = (!dataFiltered.length && canReset) || !dataFiltered.length;

  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Schedule List"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Schedule', href: paths.dashboard.schedule.root },
          { name: 'Schedule List' },
        ]}
        action={
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Button
              startIcon={<Iconify icon="mingcute:add-line" />}
              variant="contained"
              color="primary"
              onClick={() => isOpenCreate.onTrue()}
            >
              Create Schedule
            </Button>
            <Button
              startIcon={<Iconify icon="solar:filter-bold-duotone" />}
              variant="outlined"
              color="primary"
              onClick={() => isOpenDatePicker.onTrue()}
            >
              Filter Date
            </Button>
          </Box>
        }
        sx={{ mb: { xs: 3, md: 5 } }}
      />

      <CustomDateRangePicker
        open={isOpenDatePicker.value}
        startDate={startDate}
        endDate={endDate}
        onCancel={() => isOpenDatePicker.onFalse()}
        onClose={handleApplyDateFilter}
        onChangeStartDate={handleStartChange}
        onChangeEndDate={handleEndChange}
        error={isDateError}
        title="Select date range"
        variant="calendar"
      />

      <ScheduleDetailDialog
        open={isOpenDetail.value}
        onClose={handleCloseDetail}
        data={selectedRow}
      />

      <ScheduleCreateDialog
        open={isOpenCreate.value}
        onClose={isOpenCreate.onFalse}
        onSuccess={handleCreateSuccess}
      />

      <Card>
        <Box sx={{ px: 2.5, py: 2 }}>
          <Typography variant="subtitle2" color="text.secondary">
            Schedule period: {startDate.format('DD/MM/YYYY')} - {endDate.format('DD/MM/YYYY')}
          </Typography>
        </Box>

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
                dataFiltered.map((row) => row.user?.userCode)
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
                    dataFiltered.map((row) => row.user?.userCode)
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
                      <ScheduleListTableRow
                        key={row.user?.userCode}
                        row={row}
                        selected={table.selected.includes(row.user?.userCode)}
                        onSelectRow={() => table.onSelectRow(row.user?.userCode)}
                        onViewDetail={() => handleViewDetail(row)}
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
  const { name } = filters;

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
        record.user?.fullName?.toLowerCase().indexOf(name.toLowerCase()) !== -1 ||
        record.user?.userCode?.toLowerCase().indexOf(name.toLowerCase()) !== -1 ||
        record.user?.email?.toLowerCase().indexOf(name.toLowerCase()) !== -1
    );
  }

  return inputData;
}
