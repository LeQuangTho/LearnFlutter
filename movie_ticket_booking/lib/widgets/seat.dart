import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/seat_status.dart';

class Seat extends StatelessWidget {
  const Seat(
      {Key? key, required this.status, this.isSeat = true, required this.name})
      : super(key: key);

  final SeatStatus status;
  final bool isSeat;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: _getColor(),
        border: Border.all(width: 4, color: Colors.black),
      ),
      child: Text(
        name,
      ),
    );
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
