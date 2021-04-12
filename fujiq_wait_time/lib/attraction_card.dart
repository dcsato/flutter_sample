import 'package:flutter/material.dart';
import 'package:fujiqwaittime/attraction.dart';
import 'package:fujiqwaittime/web_detail.dart';

class AttractionCard extends StatelessWidget {
  final Attraction attraction;
  AttractionCard(this.attraction);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        child: Image.asset('assets/images/' + attraction.picture),
      ),
      title: Text(
        attraction.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        attraction.time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.orange,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WebDetail(attraction.urlLink, attraction.name),
          ),
        );
      },
    );
  }
}
