import 'dart:convert';

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
            .map((e1) => Row(
                  children: [
                    ...e1.value.asMap().entries.map((e2) {
                      return Seat(
                        maxSeatOfRow: e1.value.length,
                        name: '${const Utf8Decoder().convert([
                              e1.key + 65
                            ])}${e2.key}',
                        isSeat: e2.value == 1,
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
