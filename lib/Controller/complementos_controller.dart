import '../Models/complementos_model.dart';
import '../Services/ComplementoService.dart';

class ComplementosController {
  ComplementosController();

  Future<List<Complementos>> buscaComplementos({required grupo}) async {
    try {
      return await fetchComplementos(grupo);
    } catch (e) {
      throw Exception(e);
    }
  }
}
