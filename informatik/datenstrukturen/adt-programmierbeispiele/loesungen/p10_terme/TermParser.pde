import java.util.ArrayList;
import java.util.Stack;

/**
 * Wandelt einen als String gegebenen Term in einen Rechenbaum um (Musterlösung).
 * Hier sollte nichts verändert werden.
 * 
 * @author Rainer Helfrich (Original) / Antigravity (Processing-Konvertierung)
 * @version September 2026
 */
public static class TermParser
{
    public static Binaerbaum<Symbol> parse(String term) throws Exception
    {
        ArrayList<String> out = tokenizeTerm(term);
        ArrayList<Symbol> postfix = buildPostfix(out);
        Binaerbaum<Symbol> rechenbaum = buildTree(postfix);
        return rechenbaum;
    }

    private static Binaerbaum<Symbol> buildTree(ArrayList<Symbol> postfix) throws Exception
    {
        if (postfix.size() == 0)
        {
            return null;
        }
        Stack<Binaerbaum<Symbol>> stack = new Stack<Binaerbaum<Symbol>>();
        for (Symbol s : postfix)
        {
            if (s.istOperator())
            {
                if (stack.size() < 2)
                {
                    throw new Exception("Fehler: Zu viele Operatoren");
                }
                Binaerbaum<Symbol> r = stack.pop();
                Binaerbaum<Symbol> l = stack.pop();
                Binaerbaum<Symbol> n = new Binaerbaum<Symbol>(s, l, r);
                stack.push(n);
            }
            else
            {
                stack.push(new Binaerbaum<Symbol>(s));
            }
        }
        if (stack.size() != 1)
        {
            throw new Exception("Fehler: Zu wenige Operatoren");
        }
        return stack.pop();
    }

    private static ArrayList<Symbol> buildPostfix(ArrayList<String> infix) throws Exception
    {
        Stack<String> stack = new Stack<String>();
        ArrayList<Symbol> postfix = new ArrayList<Symbol>();
        for(String token : infix)
        {
            if (isNumeric(token))
            {
                postfix.add(new Symbol(token));
            }
            else if (token.equals("("))
            {
                stack.push(token);
            }
            else if (token.equals(")"))
            {
                while(true)
                {
                    if (stack.isEmpty())
                    {
                        throw new Exception("Fehler: Ungültiger Term.");
                    }
                    String t = stack.pop();
                    if (t.equals("("))
                    {
                        break;
                    }
                    postfix.add(new Symbol(t));
                }
            }
            else 
            {
                while (!stack.isEmpty())
                {
                    String top = stack.peek();
                    if ("+-*/".contains(top) && ("+-".contains(token) || "*/".contains(top)))
                    {
                        stack.pop();
                        postfix.add(new Symbol(top));
                    }
                    else
                    {
                        break;
                    }
                }
                stack.push(token);
            }
        }
        while(!stack.isEmpty())
        {
            String top = stack.pop();
            if (top.equals("("))
            {
                throw new Exception("Fehler: Ungültig geklammerter Term");
            }
            postfix.add(new Symbol(top));
        }
        return postfix;
    }

    private static boolean isNumeric(String s)
    {
        try
        {
            Integer.parseInt(s);
            return true;
        }
        catch(Exception x)
        {
        }
        return false;
    }

    private static ArrayList<String> tokenizeTerm(String strTerm) throws Exception
    {
        char[] term = strTerm.toCharArray();
        ArrayList<String> tokens = new ArrayList<String>();
        String numberToken = null;
        for (char c : term)
        {
            if (Character.isDigit(c))
            {
                if (numberToken == null)
                    numberToken = "";
                numberToken += String.valueOf(c);
            }
            else if ("+-*/()".contains(String.valueOf(c)) || Character.isWhitespace(c))
            {
                if (numberToken != null)
                {
                    tokens.add(numberToken);
                    numberToken = null;
                }
                if (!Character.isWhitespace(c))
                {
                    tokens.add(String.valueOf(c));
                }
            }
            else
            {
                throw new Exception("Fehler: Ungültige Zeichen in Term.");
            }
        }
        if (numberToken != null)
        {
            tokens.add(numberToken);
        }
        return tokens;
    }
}
