import Stack from '@mui/material/Stack';
import { Skeleton } from '@mui/material';
import Tooltip from '@mui/material/Tooltip';
import Checkbox from '@mui/material/Checkbox';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import IconButton from '@mui/material/IconButton';

import { Iconify } from 'src/components/iconify';

// ======================================================================

export function ShiftTableRow({ row, selected, onSelectRow, onDeleteRow }) {
  return (
    <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
      <TableCell padding="checkbox">
        <Checkbox checked={selected} onClick={onSelectRow} />
      </TableCell>

      {/* Shift Code */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.shiftCode}</TableCell>

      {/* Shift Name */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.name}</TableCell>

      {/* Start Time */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.startTime}</TableCell>

      {/* End Time */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.endTime}</TableCell>

      {/* Allowable Delay */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.allowableDelay || 0}</TableCell>

      {/* Status */}
      <TableCell sx={{ whiteSpace: 'nowrap' }}>
        {row.isActive === 'Y' ? 'Active' : 'Inactive'}
      </TableCell>

      {/* Actions */}
      <TableCell>
        <Stack direction="row" alignItems="center">
          <Tooltip title="Delete">
            <IconButton color="error" onClick={onDeleteRow} size="small">
              <Iconify icon="solar:trash-bin-trash-bold" />
            </IconButton>
          </Tooltip>
        </Stack>
      </TableCell>
    </TableRow>
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
