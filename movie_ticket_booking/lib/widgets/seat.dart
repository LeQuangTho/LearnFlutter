import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/seat_status.dart';
import 'package:sizer/sizer.dart';

class Seat extends StatelessWidget {
  const Seat(
      {Key? key,
      required this.status,
      this.isSeat = true,
      required this.name,
      required this.maxSeatOfRow})
      : super(key: key);

  final SeatStatus status;
  final bool isSeat;
  final String name;
  final int maxSeatOfRow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('object'),
      child: Container(
        margin: EdgeInsets.all(_getSizeWidthSeat() * 0.05),
        height: _getSizeWidthSeat() * 0.9,
        width: _getSizeWidthSeat() * 0.9,
        decoration: BoxDecoration(
            color: _getColor(),
            borderRadius: BorderRadius.circular(_getSizeWidthSeat() * 0.2)),
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontSize: _getSizeWidthSeat() * 0.3),
          ),
        ),
      ),
    );
  }

  _getSizeWidthSeat() {
    return 100.w / maxSeatOfRow;
  }

  _getColor() {
    if (!isSeat) {
      return Colors.black87;
    }
    switch (status) {
      case SeatStatus.selected:
        return Colors.red;
      case SeatStatus.occupied:
        return Colors.grey;
      case SeatStatus.vip:
        return Colors.purple;
      case SeatStatus.none:
        return Colors.redAccent;
    }
  }
}
