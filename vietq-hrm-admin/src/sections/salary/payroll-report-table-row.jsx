import Link from '@mui/material/Link';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import Checkbox from '@mui/material/Checkbox';
import MenuItem from '@mui/material/MenuItem';
import MenuList from '@mui/material/MenuList';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import { Avatar, Skeleton } from '@mui/material';
import IconButton from '@mui/material/IconButton';

import { useBoolean } from 'src/hooks/use-boolean';

import { CONFIG } from 'src/config-global';

import { Iconify } from 'src/components/iconify';
import { ConfirmDialog } from 'src/components/custom-dialog';
import { usePopover, CustomPopover } from 'src/components/custom-popover';

// ----------------------------------------------------------------------

export function PayrollReportTableRow({ row, selected, onSelectRow, onDeleteRow }) {
  const confirm = useBoolean();
  const popover = usePopover();

  // Format dates
  const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('vi-VN');
  };

  // Get avatar URL with fallback
  const avatarUrl = row.user?.avatar
    ? CONFIG.site.imageUrl + row.user.avatar
    : '/assets/images/avatars/avatar_default.jpg';

  return (
    <>
      <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
        <TableCell padding="checkbox">
          <Checkbox id={row.id} checked={selected} onClick={onSelectRow} />
        </TableCell>

        {/* Avatar */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          <Avatar alt={row.user?.fullName} src={avatarUrl} sx={{ width: 48, height: 48 }} />
        </TableCell>

        {/* Full Name */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.user?.fullName || '-'}</TableCell>

        {/* User Code */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.user?.userCode || '-'}</TableCell>

        {/* Payroll Code */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.payroll?.payrollCode || '-'}</TableCell>

        {/* Payroll Name */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.payroll?.payrollName || '-'}</TableCell>

        {/* Payslip File */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {row.payslipFile ? (
            <Link
              href={`${CONFIG.site.imageUrl}${row.payslipFile}`}
              target="_blank"
              rel="noopener noreferrer"
              sx={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 0.5 }}
            >
              <Iconify icon="eva:download-fill" />
              Download
            </Link>
          ) : (
            '-'
          )}
        </TableCell>

        {/* Start Date */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{formatDate(row.payroll?.startDate)}</TableCell>

        {/* End Date */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{formatDate(row.payroll?.endDate)}</TableCell>

        {/* Payment Date */}
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{formatDate(row.payroll?.paymentDate)}</TableCell>

        {/* Actions */}
        <TableCell>
          <Stack direction="row" alignItems="center">
            <Tooltip title="Download" placement="top" arrow>
              <IconButton
                color="default"
                onClick={() => {
                  if (row.payslipFile) {
                    window.open(`${CONFIG.site.imageUrl}${row.payslipFile}`, '_blank');
                  }
                }}
              >
                <Iconify icon="eva:download-fill" />
              </IconButton>
            </Tooltip>

            <Tooltip title="Delete" placement="top" arrow>
              <IconButton color="primary" onClick={confirm.onTrue}>
                <Iconify icon="solar:trash-bin-trash-bold" />
              </IconButton>
            </Tooltip>

            <IconButton color={popover.open ? 'inherit' : 'default'} onClick={popover.onOpen}>
              <Iconify icon="eva:more-vertical-fill" />
            </IconButton>
          </Stack>
        </TableCell>
      </TableRow>

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
        content="Are you sure want to delete this payslip?"
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
