import React, { useState, useEffect, useCallback } from 'react';

import {
  Box,
  Card,
  Table,
  Button,
  Tooltip,
  MenuItem,
  TableBody,
  TextField,
  IconButton,
} from '@mui/material';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useBoolean } from 'src/hooks/use-boolean';
import { useSetState } from 'src/hooks/use-set-state';

import { _roles } from 'src/_mock';
import SalaryApi from 'src/services/api/salary.api';
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

import CreateReportForm from '../payroll-create-report';
import { TableSkeleton, PayrollReportTableRow } from '../payroll-report-table-row';

const TABLE_HEAD = [
  { id: 'avatar', label: 'Avatar', width: 100 },
  { id: 'fullName', label: 'Full Name', width: 150 },
  { id: 'userCode', label: 'User Code', width: 120 },
  { id: 'payrollCode', label: 'Payroll Code', width: 150 },
  { id: 'payrollName', label: 'Payroll Name', width: 150 },
  { id: 'payslipFile', label: 'Payslip File', width: 200 },
  { id: 'startDate', label: 'Start Date', width: 120 },
  { id: 'endDate', label: 'End Date', width: 120 },
  { id: 'paymentDate', label: 'Payment Date', width: 120 },
  { id: 'actions', label: 'Actions', width: 100 },
];

// Tạo danh sách tháng
const MONTH_OPTIONS = Array.from({ length: 12 }, (_, i) => ({
  value: String(i + 1).padStart(2, '0'),
  label: `Tháng ${i + 1}`,
}));

// Tạo danh sách năm
const YEAR_OPTIONS = Array.from({ length: 5 }, (_, i) => ({
  value: new Date().getFullYear() - 2 + i,
  label: `${new Date().getFullYear() - 2 + i}`,
}));

export function SalaryReportView() {
  const router = useRouter();
  const openModal = useBoolean();
  const confirm = useBoolean();

  const table = useTable({ defaultRowsPerPage: 5 });

  const [tableData, setTableData] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedMonth, setSelectedMonth] = useState(
    String(new Date().getMonth() + 1).padStart(2, '0')
  );
  const [selectedYear, setSelectedYear] = useState(String(new Date().getFullYear()));
  const filters = useSetState({ name: '', role: [], status: 'all' });

  // Fetch payslip list khi component mount
  useEffect(() => {
    fetchPayslipList(`${selectedYear}-${selectedMonth}-01`);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const fetchPayslipList = async (month = '') => {
    try {
      setIsLoading(true);
      // Chỉ gửi month nếu có, nếu không gửi year để lọc theo năm
      const response = await SalaryApi.getPayslipList(month || '');
      console.log('Payslip list:', response);
      setTableData(response || []);
    } catch (error) {
      console.error('Failed to fetch payslip list:', error);
      toast.error('Failed to load payslip data');
    } finally {
      setIsLoading(false);
    }
  };

  const handleMonthChange = (e) => {
    const month = e.target.value;
    setSelectedMonth(month);
    table.onResetPage();
    // Khi chọn tháng, gửi cả month và year
    fetchPayslipList(`${selectedYear}-${month}-01`);
  };

  const handleYearChange = (e) => {
    const year = e.target.value;
    setSelectedYear(year);
    table.onResetPage();
    // Khi chọn năm, gửi selectedMonth (nếu có) và year mới
    fetchPayslipList(`${year}-${selectedMonth}-01`);
  };

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
        <Box sx={{ p: 2.5, display: 'flex', gap: 2, alignItems: 'flex-end' }}>
          <TextField
            select
            label="Chọn tháng"
            value={selectedMonth}
            onChange={handleMonthChange}
            sx={{ minWidth: 150 }}
          >
            {MONTH_OPTIONS.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            select
            label="Chọn năm"
            value={selectedYear}
            onChange={handleYearChange}
            sx={{ minWidth: 150 }}
          >
            {YEAR_OPTIONS.map((option) => (
              <MenuItem key={option.value} value={String(option.value)}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        </Box>

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

              {isLoading ? (
                <TableSkeleton length={TABLE_HEAD.length + 1} />
              ) : (
                <TableBody>
                  {dataInPage.map((row) => (
                    <PayrollReportTableRow
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

      <CreateReportForm open={openModal.value} handleClose={openModal.onFalse} />
    </DashboardContent>
  );
}

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
        record.payroll?.payrollName?.toLowerCase().indexOf(name.toLowerCase()) !== -1 ||
        record.payroll?.payrollCode?.toLowerCase().indexOf(name.toLowerCase()) !== -1
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
