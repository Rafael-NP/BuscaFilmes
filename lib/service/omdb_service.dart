import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filme.dart';

class OmdbService {
  final String apiKey = '422dc465';

  Future<List<Filme>> buscarFilmes(String nomeFilme) async {
    List<Filme> listaFilmes = [];

    final urlBusca = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        's': nomeFilme,
        'apikey': apiKey,
      },
    );

    final responseBusca = await http.get(urlBusca);

    print(responseBusca.body);

    final dadosBusca = json.decode(responseBusca.body);

    if (dadosBusca['Response'] == 'False') {
      throw Exception(dadosBusca['Error']);
    }

    if (dadosBusca['Search'] != null) {
      for (var item in dadosBusca['Search']) {
        final imdbID = item['imdbID'];

        final urlDetalhes = Uri.https(
          'www.omdbapi.com',
          '/',
          {
            'i': imdbID,
            'plot': 'short',
            'apikey': apiKey,
          },
        );

        final responseDetalhes =
            await http.get(urlDetalhes);

        final dadosDetalhes =
            json.decode(responseDetalhes.body);

        listaFilmes.add(
          Filme.fromJson(dadosDetalhes),
        );
      }
    }

    return listaFilmes;
  }
}