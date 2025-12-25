//
//  EnhancedSyntaxHighlighter.mm
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedSyntaxHighlighter.h"
#import "SciLexer.h"
#import "Lexilla.h"
#import "ScintillaCocoa.h"

@implementation EnhancedSyntaxHighlighter

+ (void)applySyntaxHighlighting:(ScintillaView *)textView forLanguage:(NSString *)language {
    // Clear any existing styling
    [textView sendmessage:SCI_CLEARDOCUMENTSTYLE sub:0 wparam:0];
    
    // Set up basic styling
    [textView sendmessage:SCI_STYLESETFORE sub:STYLE_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETBACK sub:STYLE_DEFAULT wparam:0xFFFFFF];
    [textView sendmessage:SCI_STYLECLEARALL sub:0 wparam:0];
    
    // Use Lexilla to create appropriate lexer
    const char *lexerName = nullptr;
    
    if ([language isEqualToString:@"C++"]) {
        lexerName = "cpp";
    } else if ([language isEqualToString:@"Python"]) {
        lexerName = "python";
    } else if ([language isEqualToString:@"JavaScript"]) {
        lexerName = "javascript";
    } else if ([language isEqualToString:@"HTML"]) {
        lexerName = "hypertext";
    } else if ([language isEqualToString:@"XML"]) {
        lexerName = "xml";
    } else if ([language isEqualToString:@"Java"]) {
        lexerName = "java";
    } else if ([language isEqualToString:@"PHP"]) {
        lexerName = "php";
    } else if ([language isEqualToString:@"Ruby"]) {
        lexerName = "ruby";
    } else if ([language isEqualToString:@"CSS"]) {
        lexerName = "css";
    } else if ([language isEqualToString:@"SQL"]) {
        lexerName = "sql";
    } else if ([language isEqualToString:@"JSON"]) {
        lexerName = "json";
    } else if ([language isEqualToString:@"YAML"]) {
        lexerName = "yaml";
    } else if ([language isEqualToString:@"Markdown"]) {
        lexerName = "markdown";
    } else if ([language isEqualToString:@"Bash"]) {
        lexerName = "bash";
    }
    
    if (lexerName) {
        ILexer5 *lexer = CreateLexer(lexerName);
        if (lexer) {
            [textView setReferenceProperty:[NSString stringWithFormat:@"lexer.%s", lexerName] value:lexer];
        }
    }
    
    if ([language isEqualToString:@"C++"]) {
        [self setupCppHighlighting:textView];
    }
    else if ([language isEqualToString:@"Python"]) {
        [self setupPythonHighlighting:textView];
    }
    else if ([language isEqualToString:@"JavaScript"]) {
        [self setupJavaScriptHighlighting:textView];
    }
    else if ([language isEqualToString:@"HTML"]) {
        [self setupHtmlHighlighting:textView];
    }
    else if ([language isEqualToString:@"XML"]) {
        [self setupXmlHighlighting:textView];
    }
    else if ([language isEqualToString:@"Java"]) {
        [self setupJavaHighlighting:textView];
    }
    else if ([language isEqualToString:@"PHP"]) {
        [self setupPhpHighlighting:textView];
    }
    else if ([language isEqualToString:@"Ruby"]) {
        [self setupRubyHighlighting:textView];
    }
    else if ([language isEqualToString:@"CSS"]) {
        [self setupCssHighlighting:textView];
    }
    else if ([language isEqualToString:@"SQL"]) {
        [self setupSqlHighlighting:textView];
    }
    else if ([language isEqualToString:@"JSON"]) {
        [self setupJsonHighlighting:textView];
    }
    else if ([language isEqualToString:@"YAML"]) {
        [self setupYamlHighlighting:textView];
    }
    else if ([language isEqualToString:@"Markdown"]) {
        [self setupMarkdownHighlighting:textView];
    }
    else if ([language isEqualToString:@"Bash"]) {
        [self setupBashHighlighting:textView];
    }
    else {
        // Plain text - no special styling
        [textView sendmessage:SCI_SETLEXER sub:SCLEX_NULL wparam:0];
    }
    
    // Refresh the view
    [textView sendmessage:SCI_COLOURISE sub:0 wparam:-1];
}

+ (void)setupCppHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_CPP wparam:0];
    
    // Set keywords
    const char *cppKeywords = "asm auto bool break case catch char class const const_cast continue default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new operator private protected public register reinterpret_cast return short signed sizeof static static_cast struct switch template this throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)cppKeywords];
    
    const char *cppKeywords2 = "alignas alignof constexpr decltype noexcept nullptr static_assert thread_local";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)cppKeywords2];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_C_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_WORD2 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_C_WORD2 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_UUID wparam:0x804080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_PREPROCESSOR wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_STRINGEOL wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_VERBATIM wparam:0x808080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_REGEX wparam:0x808080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTLINEDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTDOCKEYWORD wparam:0x008000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_C_COMMENTDOCKEYWORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTDOCKEYWORDERROR wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_GLOBALCLASS wparam:0x000000];
}

+ (void)setupPythonHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_PYTHON wparam:0];
    
    // Set keywords
    const char *pythonKeywords = "and as assert break class continue def del elif else except exec finally for from global if import in is lambda not or pass print raise return try while with yield";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)pythonKeywords];
    
    const char *pythonKeywords2 = "self cls";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)pythonKeywords2];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_P_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLE wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLEDOUBLE wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_CLASSNAME wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_DEFNAME wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTBLOCK wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRINGEOL wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD2 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_DECORATOR wparam:0x804000];
}

+ (void)setupJavaScriptHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_JAVASCRIPT wparam:0];
    
    // Set keywords
    const char *jsKeywords = "abstract boolean break byte case catch char class const continue debugger default delete do double else enum export extends final finally float for function goto if implements import in instanceof int interface long native new package private protected public return short static super switch synchronized this throw throws transient try typeof var void volatile while with";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)jsKeywords];
    
    const char *jsKeywords2 = "true false null undefined NaN Infinity";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)jsKeywords2];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_JS_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_WORD2 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRINGEOL wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_REGEX wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTLINEDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTDOCKEYWORD wparam:0x008000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_JS_COMMENTDOCKEYWORD wparam:1];
}

+ (void)setupHtmlHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_HTML wparam:0];
    
    // Set keywords
    const char *htmlTags = "a abbr acronym address applet area b base basefont bdo big blockquote body br button caption center cite code col colgroup dd del dfn dir div dl dt em fieldset font form frame frameset h1 h2 h3 h4 h5 h6 head hr html i iframe img input ins isindex kbd label legend li link map menu meta noframes noscript object ol optgroup option p param pre q s samp script select small span strike strong style sub sup table tbody td textarea tfoot th thead title tr tt u ul var xml xmlns";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)htmlTags];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAG wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAG wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGUNKNOWN wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGUNKNOWN wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTE wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTEUNKNOWN wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_DOUBLESTRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_SINGLESTRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_OTHER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ENTITY wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGEND wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGEND wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_XMLSTART wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_XMLSTART wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_XMLEND wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_XMLEND wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_SCRIPT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ASP wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ASPAT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_CDATA wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_QUESTION wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_QUESTION wparam:1];
}

+ (void)setupXmlHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_XML wparam:0];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAG wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAG wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGUNKNOWN wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGUNKNOWN wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTE wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTEUNKNOWN wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_DOUBLESTRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_SINGLESTRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_OTHER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ENTITY wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGEND wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGEND wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_XMLSTART wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_XMLSTART wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_XMLEND wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_XMLEND wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_CDATA wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_QUESTION wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_H_QUESTION wparam:1];
}

+ (void)setupJavaHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_JAVA wparam:0];
    
    // Set keywords
    const char *javaKeywords = "abstract assert boolean break byte case catch char class const continue default do double else enum extends final finally float for goto if implements import instanceof int interface long native new package private protected public return short static strictfp super switch synchronized this throw throws transient try var void volatile while";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)javaKeywords];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_COMMENTDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_J_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_COMMENTLINEDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_J_COMMENTDOCKEYWORD wparam:0x008000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_J_COMMENTDOCKEYWORD wparam:1];
}

+ (void)setupPhpHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_PHPSCRIPT wparam:0];
    
    // Set keywords
    const char *phpKeywords = "abstract and array as break case catch class clone const continue declare default do echo else elseif enddeclare endfor endforeach endif endswitch endwhile eval exit extends final for foreach function global goto if implements include include_once instanceof insteadof interface isset list namespace new or print private protected public require require_once return static switch throw trait try unset use var while xor";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)phpKeywords];
    
    const char *phpFunctions = "abs acos acosh addcslashes addslashes aggregate aggregate_info aggregate_methods aggregate_methods_by_list aggregate_methods_by_regexp aggregate_properties aggregate_properties_by_list aggregate_properties_by_regexp apache_child_terminate apache_get_modules apache_get_version apache_getenv apache_lookup_uri apache_note apache_request_headers apache_response_headers apache_setenv apd_breakpoint apd_callstack apd_clunk apd_continue apd_croak apd_dump_function_table apd_dump_persistent_resources apd_dump_regular_resources apd_echo apd_get_active_symbols apd_set_pprof_trace apd_set_session apd_set_session_trace apd_set_socket_session_trace array array_change_key_case array_chunk array_combine array_count_values array_diff array_diff_assoc array_diff_key array_diff_uassoc array_diff_ukey array_fill array_fill_keys array_filter array_flip array_intersect array_intersect_assoc array_intersect_key array_intersect_uassoc array_intersect_ukey array_key_exists array_keys array_map array_merge array_merge_recursive array_multisort array_pad array_pop array_product array_push array_rand array_reduce array_reverse array_search array_shift array_slice array_splice array_sum array_udiff array_udiff_assoc array_udiff_uassoc array_uintersect array_uintersect_assoc array_uintersect_uassoc array_unique array_unshift array_values array_walk array_walk_recursive arsort ascii2ebcdic asin asinh asort assert assert_options atan atan2 atanh base64_decode base64_encode basename bcadd bccomp bcdiv bcmod bcmul bcompiler_load bcompiler_load_exe bcompiler_parse_class bcompiler_read bcompiler_write_class bcompiler_write_constant bcompiler_write_exe_footer bcompiler_write_file bcompiler_write_footer bcpow bcpowmod bcscale bcsqrt bcsub bin2hex bindec bind_textdomain_codeset bindtextdomain bzclose bzcompress bzdecompress bzerrno bzerror bzerrstr bzflush bzopen bzread bzwrite cache_restore cache_store cal_days_in_month cal_from_jd cal_info cal_to_jd call_user_func call_user_func_array call_user_method call_user_method_array ccvs_add ccvs_auth ccvs_command ccvs_count ccvs_delete ccvs_done ccvs_init ccvs_lookup ccvs_new ccvs_report ccvs_return ccvs_reverse ccvs_sale ccvs_status ccvs_textvalue ccvs_void ceil chdir checkdate checkdnsrr chgrp chmod chop chown chr chroot chunk_split class_exists clearstatcache closedir closelog com com_addref com_create_guid com_event_sink com_get com_get_active_object com_invoke com_isenum com_load com_load_typelib com_message_pump com_print_typeinfo com_propget com_propput com_propset com_release com_set compact connection_aborted connection_status constant convert_cyr_string convert_uudecode convert_uuencode copy cos cosh count count_chars cpdf_add_annotation cpdf_add_outline cpdf_arc cpdf_begin_text cpdf_circle cpdf_clip cpdf_close cpdf_closepath cpdf_closepath_fill_stroke cpdf_closepath_stroke cpdf_continue_text cpdf_curveto cpdf_end_text cpdf_fill cpdf_fill_stroke cpdf_finalize cpdf_finalize_page cpdf_global_set_document_limits cpdf_import_jpeg cpdf_lineto cpdf_moveto cpdf_newpath cpdf_open cpdf_output_buffer cpdf_page_init cpdf_place_inline_image cpdf_rect cpdf_restore cpdf_rlineto cpdf_rmoveto cpdf_rotate cpdf_rotate_text cpdf_save cpdf_save_to_file cpdf_scale cpdf_set_action_url cpdf_set_char_spacing cpdf_set_creator cpdf_set_current_page cpdf_set_font cpdf_set_font_directories cpdf_set_font_map_file cpdf_set_horiz_scaling cpdf_set_keywords cpdf_set_leading cpdf_set_page_animation cpdf_set_subject cpdf_set_text_matrix cpdf_set_text_pos cpdf_set_text_rendering cpdf_set_text_rise cpdf_set_title cpdf_set_viewer_preferences cpdf_set_word_spacing cpdf_setdash cpdf_setflat cpdf_setgray cpdf_setgray_fill cpdf_setgray_stroke cpdf_setlinecap cpdf_setlinejoin cpdf_setlinewidth cpdf_setmiterlimit cpdf_setrgbcolor cpdf_setrgbcolor_fill cpdf_setrgbcolor_stroke cpdf_show cpdf_show_xy cpdf_stringwidth cpdf_stroke cpdf_text cpdf_translate crack_check crack_closedict crack_getlastmessage crack_opendict crc32 create_function crypt ctype_alnum ctype_alpha ctype_cntrl ctype_digit ctype_graph ctype_lower ctype_print ctype_punct ctype_space ctype_upper ctype_xdigit curl_close curl_copy_handle curl_errno curl_error curl_exec curl_getinfo curl_init curl_multi_add_handle curl_multi_close curl_multi_exec curl_multi_getcontent curl_multi_info_read curl_multi_init curl_multi_remove_handle curl_multi_select curl_setopt curl_setopt_array curl_version current cybercash_base64_decode cybercash_base64_encode cybercash_decr";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)phpFunctions];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_UDL_SSL_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_STRINGEOL wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_VARIABLE wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_UDL_SSL_IDENTIFIER wparam:0x000000];
}

+ (void)setupRubyHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_RUBY wparam:0];
    
    // Set keywords
    const char *rubyKeywords = "__FILE__ and def end in or self unless __LINE__ begin defined? ensure module redo super until BEGIN break do false next rescue then when END case else for nil retry true while alias class elsif if not return undef yield";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)rubyKeywords];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_RB_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_REGEX wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_GLOBAL wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_SYMBOL wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_MODULE_NAME wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_INSTANCE_VAR wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_CLASS_VAR wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_RB_DEFINE wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_RB_DEFINE wparam:1];
}

+ (void)setupCssHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_CSS wparam:0];
    
    // Set keywords
    const char *cssProperties = "align-content align-items align-self animation animation-delay animation-direction animation-duration animation-fill-mode animation-iteration-count animation-name animation-play-state animation-timing-function backface-visibility background background-attachment background-blend-mode background-clip background-color background-image background-origin background-position background-repeat background-size border border-bottom border-bottom-color border-bottom-left-radius border-bottom-right-radius border-bottom-style border-bottom-width border-collapse border-color border-image border-image-outset border-image-repeat border-image-slice border-image-source border-image-width border-left border-left-color border-left-style border-left-width border-radius border-right border-right-color border-right-style border-right-width border-spacing border-style border-top border-top-color border-top-left-radius border-top-right-radius border-top-style border-top-width border-width bottom box-shadow box-sizing caption-side clear clip color column-count column-fill column-gap column-rule column-rule-color column-rule-style column-rule-width column-span column-width columns content counter-increment counter-reset cursor direction display empty-cells flex flex-basis flex-direction flex-flow flex-grow flex-shrink flex-wrap float font font-family font-feature-settings font-kerning font-language-override font-size font-size-adjust font-stretch font-style font-synthesis font-variant font-variant-alternates font-variant-caps font-variant-east-asian font-variant-ligatures font-variant-numeric font-variant-position font-weight grid grid-area grid-auto-columns grid-auto-flow grid-auto-position grid-auto-rows grid-column grid-column-start grid-column-end grid-row grid-row-start grid-row-end grid-template grid-template-areas grid-template-columns grid-template-rows height hyphens image-rendering isolation justify-content left letter-spacing line-height list-style list-style-image list-style-position list-style-type margin margin-bottom margin-left margin-right margin-top max-height max-width min-height min-width object-fit object-position opacity order orphans outline outline-color outline-offset outline-style outline-width overflow overflow-wrap overflow-x overflow-y padding padding-bottom padding-left padding-right padding-top page-break-after page-break-before page-break-inside perspective perspective-origin pointer-events position quotes resize right shape-image-threshold shape-margin shape-outside tab-size table-layout text-align text-align-last text-combine-horizontal text-decoration text-decoration-color text-decoration-line text-decoration-style text-indent text-orientation text-overflow text-rendering text-shadow text-transform text-underline-position top transform transform-origin transform-style transition transition-delay transition-duration transition-property transition-timing-function unicode-bidi vertical-align visibility white-space widows width word-break word-spacing word-wrap writing-mode z-index";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)cssProperties];
    
    const char *cssPseudo = "active after before checked disabled empty enabled first first-child first-letter first-line first-of-type focus hover in-range indeterminate invalid lang last-child last-of-type left link not nth-child nth-last-child nth-last-of-type nth-of-type only-child only-of-type optional out-of-range read-only read-write required right root target valid visited";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)cssPseudo];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_TAG wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_CLASS wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_PSEUDOCLASS wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_UNKNOWN_PSEUDOCLASS wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_UNKNOWN_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_VALUE wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_ID wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_IMPORTANT wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_CSS_IMPORTANT wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_CSS_DIRECTIVE wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_CSS_DIRECTIVE wparam:1];
}

+ (void)setupSqlHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_SQL wparam:0];
    
    // Set keywords
    const char *sqlKeywords = "absolute action add admin after aggregate alias all allocate alter and any are array as asc assertion at authorization before begin binary blob boolean both breadth by call cascade cascaded case cast catalog char character check class clob close collate collation column commit completion connect connection constraint constraints constructor continue corresponding create cross cube current current_date current_path current_role current_time current_timestamp current_user cursor cycle data date day deallocate dec decimal declare default deferrable deferred delete depth deref desc describe descriptor destroy destructor deterministic dictionary diagnostics disconnect dispatch distinct domain double drop dynamic each else end end-exec equals escape every except exception exec execute external false fetch first float for foreign found from free full function general get global go goto grant group grouping having host hour identity if ignore immediate in indicator initially inner inout input insert int integer intersect interval into is isolation iterate join key language large last lateral leading left less level like limit local localtime localtimestamp locator map match minute modifies modify module month names national natural nchar nclob new next no none not null numeric object of off old on only open operation option or order ordinality out outer output pad parameter parameters partial path postfix precision prefix preorder prepare preserve primary prior privileges procedure public read reads real recursive ref references referencing relative restrict result return returns revoke right role rollback rollup routine row rows savepoint schema scroll scope search second section select sequence session session_user set sets size smallint some| space specific specifictype sql sqlexception sqlstate sqlwarning start state statement static structure system_user table temporary terminate than then time timestamp timezone_hour timezone_minute to trailing transaction translation treat trigger true under union unique unknown unnest update usage user using value values varchar variable varying view when whenever where with without work write year zone";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)sqlKeywords];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_COMMENTDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_SQL_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_QUOTEDIDENTIFIER wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_SQLPLUS_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_COMMENTLINEDOC wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SQL_COMMENTDOCKEYWORD wparam:0x008000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_SQL_COMMENTDOCKEYWORD wparam:1];
}

+ (void)setupJsonHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_JSON wparam:0];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_STRINGEOL wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_PROPERTYNAME wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_ESCAPESEQUENCE wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_LINECOMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_BLOCKCOMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_URI wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETUNDERLINE sub:SCE_JSON_URI wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_COMPACTIRI wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_KEYWORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_JSON_KEYWORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JSON_LDKEYWORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_JSON_LDKEYWORD wparam:1];
}

+ (void)setupYamlHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_YAML wparam:0];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_COMMENT wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_IDENTIFIER wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_KEYWORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_YAML_KEYWORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_REFERENCE wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_DOCUMENT wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_TEXT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_ERROR wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_YAML_OPERATOR wparam:0x000000];
}

+ (void)setupMarkdownHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_MARKDOWN wparam:0];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_LINE_BEGIN wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_STRONG1 wparam:0x000000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_STRONG1 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_STRONG2 wparam:0x000000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_STRONG2 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_EM1 wparam:0x000000];
    [textView sendmessage:SCI_STYLESETITALIC sub:SCE_MARKDOWN_EM1 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_EM2 wparam:0x000000];
    [textView sendmessage:SCI_STYLESETITALIC sub:SCE_MARKDOWN_EM2 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER1 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER1 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER2 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER2 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER3 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER3 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER4 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER4 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER5 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER5 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HEADER6 wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_MARKDOWN_HEADER6 wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_PRECHAR wparam:0x808080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_ULIST_ITEM wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_OLIST_ITEM wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_BLOCKQUOTE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_STRIKEOUT wparam:0x808080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_HRULE wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_LINK wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETUNDERLINE sub:SCE_MARKDOWN_LINK wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_CODE wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_CODE2 wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_MARKDOWN_CODEBK wparam:0xFF00FF];
}

+ (void)setupBashHighlighting:(ScintillaView *)textView {
    [textView sendmessage:SCI_SETLEXER sub:SCLEX_BASH wparam:0];
    
    // Set keywords
    const char *bashKeywords = "if then else elif fi for while until do done case esac function";
    [textView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)bashKeywords];
    
    const char *bashCommands = "alias apropos awk basename bash bc bg builtin bzip2 cal cat cd cfdisk chgrp chmod chown chroot cksum clear cmp comm command cp cron crontab csplit cut date dc dd ddrescue declare df diff diff3 dig dir dircolors dirname dirs du echo egrep eject enable env ethtool eval exec exit expand export expr false fdformat fdisk fg fgrep file find fmt fold format free fsck ftp gawk getopts grep groups gzip hash head history hostname id ifconfig import install join kill less let ln local locate logname logout look lpc lpr lprint lprintd lprintq lprm ls lsof make man mkdir mkfifo mkisofs mknod more mount mtools mv netstat nice nl nohup nslookup open op passwd paste pathchk ping popd pr printcap printenv printf ps pushd pwd quota quotacheck quotactl ram rcp read readonly renice remsync rm rmdir rsync screen scp sdiff sed select seq set sftp shift shopt shutdown sleep sort source split ssh strace su sudo sum symlink sync tail tar tee test time times touch top traceroute trap tr true tsort tty type ulimit umask umount unalias uname unexpand uniq units unset unshar useradd usermod users uuencode uudecode v vdir vi watch wc whereis which who whoami Wget xargs yes";
    [textView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)bashCommands];
    
    // Style settings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_DEFAULT wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_COMMENTLINE wparam:0x008000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_NUMBER wparam:0xFF8000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_WORD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCE_SH_WORD wparam:1];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_STRING wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_CHARACTER wparam:0xFF00FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_OPERATOR wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_IDENTIFIER wparam:0x000000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_SCALAR wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_PARAM wparam:0x800080];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_BACKTICKS wparam:0x804000];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_HERE_DELIM wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_SH_HERE_Q wparam:0xFF00FF];
}

+ (void)setupCodeFolding:(ScintillaView *)textView {
    // Enable folding
    [textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold" lpstr:"1"];
    [textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold.compact" lpstr:"0"];
    [textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold.comment" lpstr:"1"];
    [textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold.preprocessor" lpstr:"1"];
    
    // Set up folding markers
    [textView sendmessage:SCI_SETMARGINTYPEN sub:2 wparam:SC_MARGIN_SYMBOL];
    [textView sendmessage:SCI_SETMARGINMASKN sub:2 wparam:SC_MASK_FOLDERS];
    [textView sendmessage:SCI_SETMARGINWIDTHN sub:2 wparam:20];
    [textView sendmessage:SCI_SETMARGINSENSITIVEN sub:2 wparam:1];
    
    // Setup folder markers
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPEN wparam:SC_MARK_BOXMINUS];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDER wparam:SC_MARK_BOXPLUS];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERSUB wparam:SC_MARK_VLINE];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERTAIL wparam:SC_MARK_LCORNER];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEREND wparam:SC_MARK_BOXPLUSCONNECTED];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPENMID wparam:SC_MARK_BOXMINUSCONNECTED];
    [textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERMIDTAIL wparam:SC_MARK_TCORNER];
    
    // Set marker colors
    for (int i = 25; i <= 31; i++) {
        [textView sendmessage:SCI_MARKERSETFORE sub:i wparam:0xFFFFFF];
        [textView sendmessage:SCI_MARKERSETBACK sub:i wparam:0x000000];
    }
}

+ (void)setupBraceMatching:(ScintillaView *)textView {
    // Highlight matching braces
    [textView sendmessage:SCI_STYLESETFORE sub:SCI_STYLE_BRACELIGHT wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBACK sub:SCI_STYLE_BRACELIGHT wparam:0xFFFF00];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCI_STYLE_BRACELIGHT wparam:1];
    
    // Highlight mismatched braces
    [textView sendmessage:SCI_STYLESETFORE sub:SCI_STYLE_BRACEBAD wparam:0x0000FF];
    [textView sendmessage:SCI_STYLESETBACK sub:SCI_STYLE_BRACEBAD wparam:0xFF0000];
    [textView sendmessage:SCI_STYLESETBOLD sub:SCI_STYLE_BRACEBAD wparam:1];
    
    // Set characters that are considered braces
    [textView sendmessage:SCI_BRACEHIGHLIGHT sub:'{' wparam:'}'];
    [textView sendmessage:SCI_BRACEHIGHLIGHT sub:'(' wparam:')'];
    [textView sendmessage:SCI_BRACEHIGHLIGHT sub:'[' wparam:']'];
}

@end