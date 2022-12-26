import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/widgets/seat.dart';

import '../constants/seats_map.dart';
import '../models/seat_status.dart';

class MapSelectSeats extends StatefulWidget {
  const MapSelectSeats({Key? key}) : super(key: key);

  @override
  State<MapSelectSeats> createState() => _MapSelectSeatsState();
}

class _MapSelectSeatsState extends State<MapSelectSeats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...seats
            .asMap()
            .entries
            .map((e) => Row(
                  children: [
                    ...e.value.asMap().entries.map((e) {
                      return Seat(
                        name:
                            (e.key.toString().toUpperCase().codeUnitAt(0) - 64)
                                .toString(),
                        isSeat: e.value == 1,
                        status: SeatStatus.none,
                      );
                    })
                  ],
                ))
            .toList()
      ],
    );
  }
}
