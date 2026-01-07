
import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/screens/reader_screen.dart';
// ============================================================================
// SURAH LIST TAB
// Clean, minimal, readable list of all Surahs
// ============================================================================

class SurahListTab extends StatelessWidget {
  final List<Chapter> surahs;

  const SurahListTab({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    if (surahs.isEmpty) {
      return const Center(child: Text('No Surahs available'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: surahs.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return _SurahListItem(surah: surah);
      },
    );
  }
}

// ============================================================================
// SURAH LIST ITEM
// Shows: Surah number, name, and subtitle (meaning/revelation place)
// ============================================================================

class _SurahListItem extends StatelessWidget {
  final Chapter surah;

  const _SurahListItem({required this.surah});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: CircleAvatar(child: Text('${surah.id}')),
      title: Text(surah.nameSimple, style: textTheme.bodyLarge),
      subtitle: Text(
        _getMalayalamMeaning('${surah.id}'),
        style: textTheme.bodySmall,
        textDirection: TextDirection.ltr,
      ),

      trailing: Column(
        children: [
          Text(surah.nameArabic, style: textTheme.titleMedium),
          Text('${surah.versesCount} Ayahs', style: textTheme.titleMedium),
        ],
      ),
      onTap: () {
        // open surah screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PageReaderScreen(initialSurahNumber: surah.id),
          ),
        );
      },
    );
  }

  String _getMalayalamMeaning(String englishMeaning) {
    // Common Surah English → Malayalam mapping
    final malayalamMeanings = {
      "1": "ഫാതിഹ (ആരംഭം)",
      "2": "ബഖറ (പശു)",
      "3": "ഇംറാൻ (ഇംറാന്റെ കുടുംബം)",
      "4": "നിസാ (സ്ത്രീകൾ)",
      "5": "മാഇദ (മേശ)",
      "6": "അൻആം (മൃഗങ്ങൾ)",
      "7": "അഅറഫ് (ഉയരങ്ങൾ)",
      "8": "അൻഫാൽ (യുദ്ധലാഭം)",
      "9": "തൗബ (പശ്ചാത്താപം)",
      "10": "യൂനുസ് (യൂനുസ്)",
      "11": "ഹൂദ് (ഹൂദ്)",
      "12": "യൂസുഫ് (യൂസുഫ്)",
      "13": "റഅദ് (കർക്കിട്ടം)",
      "14": "ഇബ്രാഹിം (ഇബ്രഹിം)",
      "15": "ഹിജ്ർ (കല്ല്)",
      "16": "നഹ്ൽ (തേനീച്ച)",
      "17": "ഇസ്‌റാ (രാത്രി യാത്ര)",
      "18": "കഹ്ഫ് (ഗുഹ)",
      "19": "മറിയം (മറിയം)",
      "20": "താ ഹാ (താ ഹാ)",
      "21": "അൻബിയ (നബിമാർ)",
      "22": "ഹജ്ജ് (ഹജ്ജ്)",
      "23": "മുഅ്മിനൂൻ (വിശ്വാസികൾ)",
      "24": "നൂർ (പ്രകാശം)",
      "25": "ഫുർഖാൻ (വിവേചനം)",
      "26": "ശുഅറാ (കവികൾ)",
      "27": "നമൽ (നമൽ)",
      "28": "ഖസസ് (കഥകൾ)",
      "29": "അൻകബൂത് (പൂട്ട)",
      "30": "റൂം (റോമാക്കാർ)",
      "31": "ലുഖ്മാൻ (ലുഖ്മാൻ)",
      "32": "സജ്ദ (സജ്ദ)",
      "33": "അഹ്സാബ് (സംഘം)",
      "34": "സബ (സബാക്കാർ)",
      "35": "ഫാതിർ (സ്രഷ്ടാവ്)",
      "36": "യാസീൻ (യാസീൻ)",
      "37": "സാഫ്ഫാത് (നിരകൾ)",
      "38": "സാദ് (സാദ്)",
      "39": "സുമർ (സംഘങ്ങൾ)",
      "40": "ഗ്ഫിറ (ക്ഷമിക്കുന്നവൻ)",
      "41": "ഫുസ്സിലത്ത് (വിശദീകരണം)",
      "42": "ശൂറാ (സമ്മേളനം)",
      "43": "സുഖുരുഫ് (സ്വർണം)",
      "44": "ദുഖാൻ (പുക)",
      "45": "ജാസിയ (നമസ്കരിക്കുന്നവർ)",
      "46": "അഹ്ഖാഫ് (മണൽക്കുന്നുകൾ)",
      "47": "മുഹമ്മദ് (മുഹമ്മദ്)",
      "48": "ഫത്ഹ് (വിജയം)",
      "49": "ഹുജുറാത് (മുറികൾ)",
      "50": "ഖാഫ് (ഖാഫ്)",
      "51": "സാരിയാത് (കാറ്റുകൾ)",
      "52": "തൂർ (പർവതം)",
      "53": "നജ്മ് (നക്ഷത്രം)",
      "54": "ഖമർ (ചന്ദ്രൻ)",
      "55": "റഹ്മാൻ (കരുണാമയൻ)",
      "56": "വാഖിഅ (നിശ്ചിതം)",
      "57": "ഹദീദ് (ലോഹം)",
      "58": "മുജാദില (വാദം)",
      "59": "ഹശ്ർ (ഒഴിപ്പിക്കൽ)",
      "60": "മുമ്തഹന (പരീക്ഷണം)",
      "61": "സഫ്ഫ് (നിര)",
      "62": "ജുമുഅ (ജുമുഅ)",
      "63": "മുനാഫിഖൂൻ (മുര്‍ത്തികൾ)",
      "64": "തഗാബുൻ (നഷ്ടം)",
      "65": "തലാഖ് (വിവാഹമോചനം)",
      "66": "തഹ്‌രീം (നിരോധനം)",
      "67": "മുൽക് (രാജ്യം)",
      "68": "ഖലം (പേന)",
      "69": "ഹാഖ (സത്യം)",
      "70": "മഅാരിജ് (ഉയർന്ന വഴികൾ)",
      "71": "നൂഹ് (നൂഹ്)",
      "72": "ജിൻ (ജിന്ന്)",
      "73": "മുസ്സമ്മിൽ (മുറുകെ പൊതിഞ്ഞിരിക്കുന്നവൻ)",
      "74": "മുദ്ദത്തിർ (മറയിൽ പൊതിഞ്ഞിരിക്കുന്നവൻ)",
      "75": "ഖിയാമ (പ്രളയം)",
      "76": "ഇൻസാൻ (മനുഷ്യൻ)",
      "77": "മുറ്സലാത് (അയച്ചവർ)",
      "78": "നബ (സുവാർത്ത)",
      "79": "നാസിയ (പുറത്തെടുക്കുന്നവർ)",
      "80": "അബസ (മുഖം തിരിച്ചു)",
      "81": "തക്വീർ (മറികടക്കൽ)",
      "82": "ഇൻഫിതാർ (പൊട്ടിത്തെറി)",
      "83": "മുതഫ്ഫിഫീൻ (മടങ്ങുന്നവർ)",
      "84": "ഇൻഷിഖാഖ് (പൊട്ടൽ)",
      "85": "ബുറൂജ് (നക്ഷത്രങ്ങൾ)",
      "86": "താരിഖ് (രാത്രി വരുന്നവൻ)",
      "87": "അഅ്‌ലാ (ഉന്നതൻ)",
      "88": "ഗാഷിയ (ആഴത്തിലുള്ളത്)",
      "89": "ഫജ്ർ (ഭടകം)",
      "90": "ബലദ് (നഗരം)",
      "91": "ഷംസ് (സൂര്യൻ)",
      "92": "ലൈ്ൽ (രാത്രി)",
      "93": "ഡുഹാ (പകൽ)",
      "94": "ഇൻഷിറാഹ് (വിശ്രമം)",
      "95": "തീൻ (തിറ്റെ)",
      "96": "അലഖ് (രക്തക്കട്ടൽ)",
      "97": "ഖദ്ർ (നിർണയം)",
      "98": "ബൈന (തെളിവ്)",
      "99": "സിസ്‌ജൽ (ഭൂകമ്പം)",
      "100": "ആദിയാത് (ദൂതർ)",
      "101": "ഖാരിഅ (വിപത്ത്)",
      "102": "തകാസുര് (മത്സരം)",
      "103": "അസ്ർ (സമയം)",
      "104": "ഹുമസ (നിന്ദകൻ)",
      "105": "ഫീൽ (യാത്ര elephant)",
      "106": "ഖുറൈഷ് (ഖുറൈഷ്)",
      "107": "മാഊൻ (സഹായം)",
      "108": "കൗസർ (പ്രധാന്യം)",
      "109": "കാഫിറൂൻ (നിഷേധിക്കുന്നവർ)",
      "110": "നസ്ർ (സഹായം)",
      "111": "ലഹബ് (പുകിളി)",
      "112": "ഇഖ്‌ലാസ് (ശുദ്ധി)",
      "113": "ഫലഖ് (പൊട്ടൽ)",
      "114": "നാസ് (മനുഷ്യർ)",
      'default': '$englishMeaning (മലയാളം)',
    };

    // Find exact match or use default
    return malayalamMeanings[englishMeaning] ?? malayalamMeanings['default']!;
  }
}
