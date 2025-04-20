#Requires AutoHotkey v2.0

class PathConverter {
    static WindowsToUnix(path) {
        ; Ex: "C:\Users\Moi\test" => "/c/Users/Moi/test"
        if (RegExMatch(path, "i)^([A-Z]):\\", &match)) {
            drive := match[1]
            path := SubStr(path, 3) ; enlève "C:\"
            path := StrReplace(path, "\", "/") ; remplace \ par /
            return "/" . drive . "/" . path
        } else {
            return path ; si ce n'est pas un chemin Windows, on le laisse tel quel
        }
    }

    static UnixToWindows(path) {
        ; Si le chemin commence par /[a-zA-Z]/, on replace /[a-zA-Z] par [A-Z]:
        ; Ex: "/c/Users/Moi/test" => "C:\Users\Moi\test"
        if (RegExMatch(path, "^/([a-zA-Z])/", &match)) {
            drive := StrUpper(match[1])
            path := drive ":" SubStr(path, 2) ; remplace "/c" par "C:"
        }
    }

    static GuessPathType(path){
        ; Devine le type de chemin (Windows ou Unix) en fonction du format
        ; S'il n'y a aucun / ou \ dans le chemin, alors ce n'est pas un chemin valide
        if !RegExMatch(path, "[/\\]")
            return "Unknown"
        
        ; S'il y a au moins un /, alors c'est un chemin Unix, sinon un Windows
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
