import dayjs from 'dayjs';
import PropTypes from 'prop-types';

import { Tooltip, Checkbox, TableRow, TableCell, IconButton } from '@mui/material';

import { Label } from 'src/components/label';
import { Iconify } from 'src/components/iconify';

export function RegistrationTableRow({ row, selected, onSelectRow, onApproveRow, onRejectRow }) {
  const { userCode, type, startDate, endDate, reason, status } = row;

  return (
    <TableRow hover selected={selected}>
      <TableCell padding="checkbox">
        <Checkbox checked={selected} onClick={onSelectRow} />
      </TableCell>
      <TableCell>{userCode}</TableCell>
      <TableCell>{type}</TableCell>
      <TableCell>{dayjs(startDate).format('DD/MM/YYYY')}</TableCell>
      <TableCell>{dayjs(endDate).format('DD/MM/YYYY')}</TableCell>
      <TableCell>{reason}</TableCell>
      <TableCell>
        <Label
          variant="soft"
          color={
            (status === 'APPROVED' && 'success') ||
            (status === 'REJECTED' && 'error') ||
            (status === 'PENDING' && 'warning') ||
            'default'
          }
        >
          {status}
        </Label>
      </TableCell>
      <TableCell align="right">
        {status === 'PENDING' && (
          <>
            <Tooltip title="Approve">
              <IconButton onClick={onApproveRow}>
                <Iconify icon="solar:check-circle-bold" color="success.main" />
              </IconButton>
            </Tooltip>
            <Tooltip title="Reject">
              <IconButton onClick={onRejectRow}>
                <Iconify icon="solar:close-circle-bold" color="error.main" />
              </IconButton>
            </Tooltip>
          </>
        )}
      </TableCell>
    </TableRow>
  );
}

RegistrationTableRow.propTypes = {
  row: PropTypes.shape({
    id: PropTypes.number,
    userCode: PropTypes.string,
    registrationCode: PropTypes.string,
    startDate: PropTypes.string,
    endDate: PropTypes.string,
    reason: PropTypes.string,
    type: PropTypes.string,
    timeIn: PropTypes.string,
    timeOut: PropTypes.string,
    status: PropTypes.string,
    isActive: PropTypes.bool,
    createdAt: PropTypes.string,
    updatedAt: PropTypes.string,
  }),
  selected: PropTypes.bool,
  onSelectRow: PropTypes.func,
  onApproveRow: PropTypes.func,
  onRejectRow: PropTypes.func,
};
