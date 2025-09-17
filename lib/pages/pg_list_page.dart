import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/pg_detail_page.dart';

import '../providers/pg_provider.dart';
import 'add_pg_page.dart';

class PGListPage extends StatefulWidget {
  @override
  _PGListPageState createState() => _PGListPageState();
}

class _PGListPageState extends State<PGListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PGProvider>(context, listen: false).loadPGs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddPGPage()),
          );
        },
      ),

      appBar: AppBar(title: Text('PG Listings')),
      body: Consumer<PGProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.pgList.isEmpty) {
            return Center(child: Text('No PGs Found.'));
          }

          return ListView.builder(
            itemCount: provider.pgList.length,
            itemBuilder: (context, index) {
              final pg = provider.pgList[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(pg.name),
                  subtitle: Text('${pg.location}\n₹${pg.priceWithFoodAC}/month'),
                  isThreeLine: true,
                  leading: pg.mainImage != null && pg.mainImage!.isNotEmpty
                      ? Image.network(pg.mainImage!, width: 80, fit: BoxFit.cover)
                      : Image.asset('images/samplePG.jpg', width: 80, fit: BoxFit.cover),

                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PGDetailPage(pg: pg),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
