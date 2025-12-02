import Stack from '@mui/material/Stack';
import { Skeleton } from '@mui/material';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import Checkbox from '@mui/material/Checkbox';
import MenuItem from '@mui/material/MenuItem';
import MenuList from '@mui/material/MenuList';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import IconButton from '@mui/material/IconButton';

import { useBoolean } from 'src/hooks/use-boolean';

import { CONFIG } from 'src/config-global';

import { Label } from 'src/components/label';
import { Iconify } from 'src/components/iconify';
import { ConfirmDialog } from 'src/components/custom-dialog';
import { usePopover, CustomPopover } from 'src/components/custom-popover';

import { UserQuickEditForm } from './user-quick-edit-form';

// ----------------------------------------------------------------------

export function UserTableRow({ row, selected, onEditRow, onSelectRow, onDeleteRow }) {
  const confirm = useBoolean();

  const popover = usePopover();

  const quickEdit = useBoolean();

  return (
    <>
      <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
        <TableCell padding="checkbox">
          <Checkbox id={row.id} checked={selected} onClick={onSelectRow} />
        </TableCell>

        <TableCell>
          <Stack spacing={2} direction="row" alignItems="center">
            <Avatar alt={row.fullName} src={CONFIG.site.imageUrl + row.avatar} />
          </Stack>
        </TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.email}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.fullName}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.phone}</TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.userCode}</TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.companyCode}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.userProfessionals[0].position}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.userProfessionals[0].employeeType}</TableCell>

        <TableCell>
          <Label
            variant="soft"
            color={
              (row.isActive === 'Y' && 'success') ||
              // (row.isActive === 'pending' && 'warning') ||
              (row.isActive === 'N' && 'error') ||
              'default'
            }
          >
            {row.status}
          </Label>
        </TableCell>

        <TableCell>
          <Stack direction="row" alignItems="center">
            <Tooltip title="Quick Edit" placement="top" arrow>
              <IconButton
                color={quickEdit.value ? 'inherit' : 'default'}
                onClick={quickEdit.onTrue}
              >
                <Iconify icon="solar:pen-bold" />
              </IconButton>
            </Tooltip>

            <IconButton color={popover.open ? 'inherit' : 'default'} onClick={popover.onOpen}>
              <Iconify icon="eva:more-vertical-fill" />
            </IconButton>
          </Stack>
        </TableCell>
      </TableRow>

      <UserQuickEditForm currentUser={row} open={quickEdit.value} onClose={quickEdit.onFalse} />

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

          <MenuItem
            onClick={() => {
              onEditRow();
              popover.onClose();
            }}
          >
            <Iconify icon="solar:pen-bold" />
            Edit
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


export function TableSkeleton({length = 5}) {
  return [...Array(5)].map((_, index) => (
    <TableRow key={index}>
      {
        [...Array(length)].map((__, i) => (
          <TableCell key={i}>
            <Skeleton />
          </TableCell>
        ))
      }
    </TableRow>
  ));
}