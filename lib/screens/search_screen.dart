import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  bool isShowUser = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: TextFormField(
         onFieldSubmitted: (String _){
setState(() {
  isShowUser = true;
});
         },
         decoration: const InputDecoration(
           labelText: 'Search for a user'
         ),
       ),
     ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: _searchController.text ).get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          return isShowUser? ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid:(snapshot.data! as dynamic).docs[index]['uid']))),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),

                    ),
                    title: Text((snapshot.data! as dynamic).docs[index]['username']),

                  ),
                );
              }
              ): FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return const CircularProgressIndicator();
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount:3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context,index) => Image.network((snapshot.data! as dynamic).docs[index]['postUrl']),
                  staggeredTileBuilder: ((index) => StaggeredTile.count(
                      (index%7 ==0)? 2:1, (index%7 ==0)?2:1,
                  )
                  ),
                  mainAxisSpacing: 4,
                  );

          });
        },

      )

    );
  }
}
