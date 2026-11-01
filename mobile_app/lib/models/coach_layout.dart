class SeatItem {
  final String seatNumber;
  final bool isWindow;
  final bool isForwardFacing;
  final bool isAisle;

  const SeatItem({
    required this.seatNumber,
    required this.isWindow,
    required this.isForwardFacing,
    this.isAisle = false,
  });
}

class Coach {
  final String name;
  final String type;
  final int totalSeats;
  final bool overallForwardDirection;
  final List<List<SeatItem>> seatRows;

  const Coach({
    required this.name,
    required this.type,
    required this.totalSeats,
    required this.overallForwardDirection,
    required this.seatRows,
  });

  /// Generate a realistic Bangladesh Railway 2x2 coach layout (e.g. Shovon Chair or Snigdha)
  factory Coach.generateSample({
    required String name,
    required String type,
    bool facesForward = true,
  }) {
    final List<List<SeatItem>> rows = [];
    int seatCounter = 1;

    for (int r = 1; r <= 15; r++) {
      // In BD coaches, seats 1-30 often face forward, and 31-60 face reverse (or vice versa)
      final rowFacesForward = facesForward ? (r <= 8) : (r > 8);

      final row = [
        // Left Window
        SeatItem(
          seatNumber: '${seatCounter++}',
          isWindow: true,
          isForwardFacing: rowFacesForward,
        ),
        // Left Aisle
        SeatItem(
          seatNumber: '${seatCounter++}',
          isWindow: false,
          isForwardFacing: rowFacesForward,
        ),
        // Right Aisle
        SeatItem(
          seatNumber: '${seatCounter++}',
          isWindow: false,
          isForwardFacing: rowFacesForward,
        ),
        // Right Window
        SeatItem(
          seatNumber: '${seatCounter++}',
          isWindow: true,
          isForwardFacing: rowFacesForward,
        ),
      ];
      rows.add(row);
    }

    return Coach(
      name: name,
      type: type,
      totalSeats: 60,
      overallForwardDirection: facesForward,
      seatRows: rows,
    );
  }
}
