import Stack from '@mui/material/Stack';
import { Skeleton } from '@mui/material';
import Button from '@mui/material/Button';
import Checkbox from '@mui/material/Checkbox';
import MenuItem from '@mui/material/MenuItem';
import MenuList from '@mui/material/MenuList';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import IconButton from '@mui/material/IconButton';

import { useBoolean } from 'src/hooks/use-boolean';

import { Iconify } from 'src/components/iconify';
import { ConfirmDialog } from 'src/components/custom-dialog';
import { usePopover, CustomPopover } from 'src/components/custom-popover';

// ----------------------------------------------------------------------

export function PayrollTableRow({
  row,
  selected,
  onEditRow,
  onSelectRow,
  onDeleteRow,
  onUpdateRow,
}) {
  const confirm = useBoolean();

  const popover = usePopover();

  const quickEdit = useBoolean();
  console.log(`[===============> ROW | `, row);

  // Format dates
  const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('vi-VN');
  };

  // Get avatar URL with fallback
  const avatarUrl = row.user?.avatar || '/assets/images/avatars/avatar_default.jpg';

  return (
    <>
      <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
        <TableCell padding="checkbox">
          <Checkbox id={row.id} checked={selected} onClick={onSelectRow} />
        </TableCell>

        {/* Full Name */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.payrollCode || '-'}</TableCell>

        {/* User Code */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.payrollName || '-'}</TableCell>

        {/* Payroll Code */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.companyCode || '-'}</TableCell>

        {/* Payroll Name */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.startDate || '-'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.endDate || '-'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.paymentDate || '-'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.isLocked || '-'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.isActive ? 'Active' : 'Inactive'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.createdAt}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.updatedAt}</TableCell>

        <TableCell>
          <Stack direction="row" alignItems="center">
            <IconButton color={popover.open ? 'inherit' : 'default'} onClick={popover.onOpen}>
              <Iconify icon="eva:more-vertical-fill" />
            </IconButton>
          </Stack>
        </TableCell>
      </TableRow>

      {/* <SalaryCreateForm currentUser={row} open={quickEdit.value} onClose={quickEdit.onFalse} onUpdateRow={onUpdateRow} /> */}

      <CustomPopover
        open={popover.open}
        anchorEl={popover.anchorEl}
        onClose={popover.onClose}
        slotProps={{ arrow: { placement: 'right-top' } }}
      >
        <MenuList>
          <MenuItem
            onClick={() => {
              confirm.onTrue();
              popover.onClose();
            }}
            sx={{ color: 'error.main' }}
          >
            <Iconify icon="solar:trash-bin-trash-bold" />
            Delete
          </MenuItem>
        </MenuList>
      </CustomPopover>

      <ConfirmDialog
        open={confirm.value}
        onClose={confirm.onFalse}
        title="Delete"
        content="Are you sure want to delete?"
        action={
          <Button variant="contained" color="error" onClick={onDeleteRow}>
            Delete
          </Button>
        }
      />
    </>
  );
}

export function TableSkeleton({ length = 5 }) {
  return [...Array(5)].map((_, index) => (
    <TableRow key={index}>
      {[...Array(length)].map((__, i) => (
        <TableCell key={i}>
          <Skeleton />
        </TableCell>
      ))}
    </TableRow>
  ));
}
