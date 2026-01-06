import React, { useState, useEffect, useCallback } from 'react';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Table from '@mui/material/Table';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import TableBody from '@mui/material/TableBody';
import IconButton from '@mui/material/IconButton';

import { paths } from 'src/routes/paths';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import ShiftApi from 'src/services/api/shift.api';
import { DashboardContent } from 'src/layouts/dashboard';

import { toast } from 'src/components/snackbar';
import { Iconify } from 'src/components/iconify';
import { Scrollbar } from 'src/components/scrollbar';
import { ConfirmDialog } from 'src/components/custom-dialog';
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

import { CreateShiftForm } from '../create-shift-form';
import { TableSkeleton, ShiftTableRow } from '../shift-table-row';

// ======================================================================

const TABLE_HEAD = [
  { id: 'shiftCode', label: 'Shift Code', width: 120 },
  { id: 'name', label: 'Shift Name', width: 150 },
  { id: 'startTime', label: 'Start Time', width: 120 },
  { id: 'endTime', label: 'End Time', width: 120 },
  { id: 'allowableDelay', label: 'Allowable Delay (mins)', width: 150 },
  { id: 'isActive', label: 'Status', width: 100 },
  { id: 'action', label: 'Action', width: 80 },
];

// ======================================================================

export const ScheduleShift = () => {
  const table = useTable({ defaultRowsPerPage: 12 });
  const confirm = useBoolean();
  const isLoading = useBoolean();
  const isOpenCreate = useBoolean();

  const [tableData, setTableData] = useState([]);
  const filters = useSetState({ name: '' });

  useEffect(() => {
    fetchShifts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const fetchShifts = async () => {
    try {
      isLoading.onTrue();
      const response = await ShiftApi.getListShift();
      setTableData(response?.data || response || []);
    } catch (error) {
      console.error('Failed to fetch shifts:', error);
      toast.error('Failed to load shifts');
    } finally {
      isLoading.onFalse();
    }
  };

  const handleDeleteRow = useCallback(
    (shiftCode) => {
      const newData = tableData.filter((row) => row.shiftCode !== shiftCode);
      setTableData(newData);
      toast.success('Shift deleted successfully!');
      table.onUpdatePageDeleteRow(dataInPage.length);
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [table, tableData]
  );

  const handleDeleteRows = useCallback(() => {
    const deleteRows = tableData.filter((row) => !table.selected.includes(row.shiftCode));
    toast.success('Delete success!');
    setTableData(deleteRows);
    table.onUpdatePageDeleteRows({
      totalRowsInPage: dataInPage.length,
      totalRowsFiltered: dataFiltered.length,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [table, tableData]);

  const dataFiltered = applyFilter({
    inputData: tableData,
    comparator: getComparator(table.order, table.orderBy),
    filters: filters.state,
  });

  const dataInPage = rowInPage(dataFiltered, table.page, table.rowsPerPage);

  const canReset = !!filters.state.name;
  const notFound = (!dataFiltered.length && canReset) || !dataFiltered.length;

  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Shift Management"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Schedule', href: paths.dashboard.schedule.root },
          { name: 'Shift Management' },
        ]}
        action={
          <Button
            onClick={isOpenCreate.onTrue}
            variant="contained"
            startIcon={<Iconify icon="mingcute:add-line" />}
          >
            New Shift
          </Button>
        }
        sx={{ mb: { xs: 3, md: 5 } }}
      />

      <Card>
        <UserTableToolbar
          filters={filters}
          isShowRole={false}
          onResetPage={table.onResetPage}
          options={{ roles: [] }}
          placeholder="Search by shift name or code..."
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
                dataFiltered.map((row) => row.shiftCode)
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
                    dataFiltered.map((row) => row.shiftCode)
                  )
                }
              />
              {isLoading.value ? (
                <TableSkeleton length={TABLE_HEAD.length + 1} />
              ) : (
                <TableBody>
                  {dataInPage.map((row) => (
                    <ShiftTableRow
                      key={row.shiftCode}
                      row={row}
                      selected={table.selected.includes(row.shiftCode)}
                      onSelectRow={() => table.onSelectRow(row.shiftCode)}
                      onDeleteRow={() => handleDeleteRow(row.shiftCode)}
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

      <CreateShiftForm
        open={isOpenCreate.value}
        onClose={isOpenCreate.onFalse}
        onSuccess={fetchShifts}
      />

      <ConfirmDialog
        open={confirm.value}
        onClose={confirm.onFalse}
        title="Delete"
        content={
          <>
            Are you sure want to delete <strong>{table.selected.length}</strong> shifts?
          </>
        }
        action={
          <Button
            variant="contained"
            color="error"
            onClick={() => {
              handleDeleteRows();
              confirm.onFalse();
            }}
          >
            Delete
          </Button>
        }
      />
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
        record.name?.toLowerCase().indexOf(name.toLowerCase()) !== -1 ||
        record.shiftCode?.toLowerCase().indexOf(name.toLowerCase()) !== -1
    );
  }

  return inputData;
}
