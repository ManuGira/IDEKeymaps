#Requires AutoHotkey v2.0

class PathConverter {
    static WindowsToUnix(path) {
        ; Si le chemin commence par [a-zA-Z]:\, on remplace [A-Z] par [a-z]:
        if (RegExMatch(path, "^([a-zA-Z]):\\", &match)) {
            drive := StrLower(match[1])
            path := "/" drive SubStr(path, 3) ; remplace "C:" par "/c"
        } 

        path := StrReplace(path, "\", "/")
        path := StrReplace(path, " ", "\ ") ; échappe les espaces avec un \
        return path
    }

    static UnixToWindows(path) {
        ; Si le chemin commence par /[a-zA-Z]/, on replace /[a-zA-Z] par [A-Z]:
        if (RegExMatch(path, "^/([a-zA-Z])/", &match)) {
            drive := StrUpper(match[1])

            path := drive ":" SubStr(path, 3) ; remplace "/c" par "C:"
        } 

        path := StrReplace(path, "\ ", " ")
        path := StrReplace(path, "/", "\")
        return path
    }

    static GuessPathType(path){
        ; Devine le type de chemin (Windows ou Unix) en fonction du format
        ; S'il n'y a aucun / ou \ dans le chemin, alors ce n'est pas un chemin valide
        if !RegExMatch(path, "[/\\]")
            return "Unknown"
        
        ; Si le chemin commence par [a-zA-Z]:, alors c'est un chemin Windows
        if RegExMatch(path, "^[a-zA-Z]:")
            return "Windows"

        ; S'il y a au moins un /, alors c'est un chemin Unix
        if RegExMatch(path, "/")
            return "Unix"
        
        return "Windows"
    }

    static SwitchPathType(path) {
        ; Devine le type de chemin et le convertit
        pathType := PathConverter.GuessPathType(path)
        if (pathType = "Windows") {
            return PathConverter.WindowsToUnix(path)
        } else if (pathType = "Unix") {
            return PathConverter.UnixToWindows(path)
        } else {
            return path ; si le type est inconnu, on le laisse tel quel
        }
    }
}
