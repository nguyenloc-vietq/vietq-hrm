import { useState, useEffect, useCallback } from 'react';

import Box from '@mui/material/Box';
import Tab from '@mui/material/Tab';
import Card from '@mui/material/Card';
import Tabs from '@mui/material/Tabs';
import Table from '@mui/material/Table';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import TableBody from '@mui/material/TableBody';
import { DatePicker } from '@mui/x-date-pickers';
import IconButton from '@mui/material/IconButton';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import { varAlpha } from 'src/theme/styles';
import PayrollApi from 'src/services/api/payroll.api';
import { _roles, ACTIVE_STATUS_OPTION } from 'src/_mock';
import { DashboardContent } from 'src/layouts/dashboard';

import { Label } from 'src/components/label';
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

import { TableSkeleton } from '../salary-table-row';
import { PayrollTableRow } from '../payroll-table-row';
import { PayrollCreateForm } from '../payroll-create-form';
import { UserTableToolbar } from '../salary-table-toolbar';
import { UserTableFiltersResult } from '../salary-table-filters-result';

// ----------------------------------------------------------------------

const STATUS_OPTIONS = [{ value: 'all', label: 'All' }, ...ACTIVE_STATUS_OPTION];

const TABLE_HEAD = [
  { id: 'payrollCode', label: 'Payroll Code', width: 100 },
  { id: 'payrollName', label: 'Payroll Name', width: 100 },
  { id: 'companyCode', label: 'Company Code', width: 100 },
  { id: 'startDate', label: 'Start Date', width: 100 },
  { id: 'endDate', label: 'End Date', width: 100 },
  { id: 'paymentDate', label: 'Payment Date', width: 100 },
  { id: 'isLocked', label: 'Is Locked', width: 100 },
  { id: 'isActive', label: 'Is Active', width: 100 },
  { id: 'createdAt', label: 'Created At', width: 100 },
  { id: 'updatedAt', label: 'Updated At', width: 100 },
  { id: 'actions', label: 'Actions', width: 100 },
];
// ----------------------------------------------------------------------

export function SalaryPayrollListView() {
  const table = useTable({ defaultRowsPerPage: 12 });

  const router = useRouter();
  const isCreate = useBoolean();
  const confirm = useBoolean();
  const isLoading = useBoolean();
  const [tableData, setTableData] = useState([]);
  useEffect(() => {
    fetchListPayroll(); // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  console.log('[==================>', table.rowsPerPage);
  const fetchListPayroll = async () => {
    try {
      isLoading.onTrue();
      const ListPayroll = await PayrollApi.getListPayroll({ type: 'all' });
      console.log(`[===============> List Payroll | `, ListPayroll);
      setTableData(ListPayroll);
    } catch (error) {
      console.log(error);
    } finally {
      isLoading.onFalse();
    }
  };
  const fetchListPayrollByYear = async (year) => {
    try {
      isLoading.onTrue();
      const ListPayroll = await PayrollApi.getListPayroll({ year });
      console.log(`[===============> List Payroll | `, ListPayroll);
      setTableData(ListPayroll);
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
    !!filters.state.name || filters.state.role.length > 0 || filters.state.isActive !== 'all';

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
      router.push(paths.dashboard.user.edit(id));
    },
    [router]
  );

  const handleFilterStatus = useCallback(
    (event, newValue) => {
      table.onResetPage();
      console.log(`[===============> filtter | `, filters);
      filters.setState({ status: newValue });
    },
    [filters, table]
  );

  return (
    <>
      <DashboardContent>
        <CustomBreadcrumbs
          heading="Payroll List"
          links={[
            { name: 'Dashboard', href: paths.dashboard.root },
            { name: 'Salary', href: paths.dashboard.salary.root },
            { name: 'Payroll List' },
          ]}
          action={
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <DatePicker
                sx={{ mr: 1, width: 100, padding: 0 }}
                views={['year']}
                name="year"
                label="Year"
                onChange={(year) => {
                  fetchListPayrollByYear(year);
                }}
              />
              <Button
                onClick={isCreate.onTrue}
                variant="contained"
                startIcon={<Iconify icon="mingcute:add-line" />}
              >
                New payroll
              </Button>
            </Box>
          }
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
                      (tab.value === 'Y' && 'success') ||
                      (tab.value === 'N' && 'error') ||
                      'default'
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
                      dataFiltered.map((row) => row.user)
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
                        <PayrollTableRow
                          key={row.payrollCode}
                          row={row}
                          selected={table.selected.includes(row.payrollCode)}
                          onUpdateRow={onUpdateRow}
                          onSelectRow={() => table.onSelectRow(row.payrollCode)}
                          onDeleteRow={() => handleDeleteRow(row.payrollCode)}
                          onEditRow={() => handleEditRow(row.payrollCode)}
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

      <PayrollCreateForm
        currentUser={dataFiltered}
        open={isCreate.value}
        onClose={isCreate.onFalse}
        onUpdateRow={onUpdateRow}
      />

      <ConfirmDialog
        open={confirm.value}
        onClose={confirm.onFalse}
        title="Delete"
        content={
          <>
            Are you sure want to delete <strong> {table.selected.length} </strong> items?
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
    </>
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
