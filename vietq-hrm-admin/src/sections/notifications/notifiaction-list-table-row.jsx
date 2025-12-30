import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';

import Stack from '@mui/material/Stack';
import { Skeleton } from '@mui/material';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
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

const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
dayjs.extend(utc);
dayjs.extend(timezone);
export function NotificationListTableRow({
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
  return (
    <>
      <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
        <TableCell padding="checkbox">
          <Checkbox id={row.id} checked={selected} onClick={onSelectRow} />
        </TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.notificationCode}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.notificationType}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.title}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.body}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.targetType}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {row.targetValue == null ? 'N/A' : row.targetValue}
        </TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {row.typeSystem === null ? 'N/A' : row.typeSystem}
        </TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {row.scheduleTime === null ? '-' : row.scheduleTime}
        </TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.openSent === 1 ? 'Yes' : 'No'}</TableCell>
        <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.isSent ? 'Yes' : 'No'}</TableCell>

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
