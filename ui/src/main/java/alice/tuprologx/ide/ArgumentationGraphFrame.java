package alice.tuprologx.ide;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Struct;
import com.google.common.collect.ImmutableMap;
import edu.uci.ics.jung.algorithms.layout.KKLayout;
import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.SparseMultigraph;
import edu.uci.ics.jung.graph.util.EdgeType;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.control.DefaultModalGraphMouse;
import edu.uci.ics.jung.visualization.control.ModalGraphMouse;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import edu.uci.ics.jung.visualization.renderers.Renderer;

import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ArgumentationGraphFrame {

    private static final String BUILD_LABEL_SETS = "buildLabelSets";

    private final JScrollPane graphPane;
    private final JScrollPane theoryPane;
    private List<Argument> arguments;
    private List<Attack> attacks;

    public ArgumentationGraphFrame(final JSplitPane argumentationGraphPane) {

        this.graphPane = new JScrollPane();
        this.theoryPane = new JScrollPane();

        argumentationGraphPane.add(this.theoryPane);
        argumentationGraphPane.add(this.graphPane);
        argumentationGraphPane.setOneTouchExpandable(true);
        argumentationGraphPane.setDividerLocation(150);

//        //Provide minimum sizes for the two components in the split pane
//        Dimension minimumSize = new Dimension(100, 50);
//        listScrollPane.setMinimumSize(minimumSize);
//        pictureScrollPane.setMinimumSize(minimumSize);
    }

    public void printArgumentationInfo(final SolveInfo info, final Prolog engine) {

        if (!(info.getQuery().toString().startsWith(BUILD_LABEL_SETS)
                && info.isSuccess())) {
            if (!info.getQuery().toString().startsWith(BUILD_LABEL_SETS)) {
                this.graphPane.getViewport().removeAll();
                this.theoryPane.getViewport().removeAll();
            }
            return;
        }

        this.arguments = Argument.mineArguments(engine);
        this.attacks = Attack.mineAttacks(engine, arguments);

        printGraph();
        printTheory();

    }

    @SuppressWarnings("rawtypes")
    private void printGraph() {

        final Layout<String, String> layout = new KKLayout<>(buildGraph());
        layout.setSize(new Dimension(350,300));

        final VisualizationViewer<String, String> vv = new VisualizationViewer<>(layout);
        vv.setPreferredSize(new Dimension(350,300));
        vv.getRenderContext().setVertexFillPaintTransformer(i -> {
            if (Argument.labelFromIdentifier(i, this.arguments).equals("in")) return Color.GREEN;
            if (Argument.labelFromIdentifier(i, this.arguments).equals("out")) return Color.RED;
            return Color.GRAY;
        });
        vv.getRenderContext().setVertexLabelTransformer(new ToStringLabeller());
        vv.getRenderer().getVertexLabelRenderer().setPosition(Renderer.VertexLabel.Position.AUTO);

        final DefaultModalGraphMouse graphMouse = new DefaultModalGraphMouse();
        graphMouse.setMode(ModalGraphMouse.Mode.PICKING);
        vv.setGraphMouse(graphMouse);

        this.graphPane.getViewport().setView(vv);
    }

    private void printTheory() {
        final JTextArea textArea = new JTextArea();
        textArea.setEditable(false);
        this.arguments.forEach(x -> textArea.append(x.getDescriptor() + "\n"));
        this.theoryPane.getViewport().setView(textArea);
    }

    private Graph<String, String> buildGraph() {

        final Graph<String, String> graph = new SparseMultigraph<>();

        this.arguments.stream()
            .map(Argument::getIdentifier)
            .forEach(graph::addVertex);

        this.attacks.forEach(x ->
                graph.addEdge(x.getAttacker().concat(x.getAttacked()),
                        x.getAttacker(),
                        x.getAttacked(),
                        EdgeType.DIRECTED));

        return graph;
    }
}

class Attack {

    private final String attacker;
    private final String attacked;

    Attack(final String attacker, final String attacked) {
        this.attacker = attacker;
        this.attacked = attacked;
    }

    public String getAttacker() {
        return this.attacker;
    }

    public String getAttacked() {
        return this.attacked;
    }

    static List<Attack> mineAttacks(final Prolog engine, final List<Argument> arguments) {
        return engine.getTheory()
            .getClauses().stream()
            .filter(x -> x.match(engine.termSolve("attack(X, Y)")))
            .map(x -> RegexHelpers.regexResults(x.toString()))
            .map(x -> new Attack(
                Argument.identifierFromRules(x.get(0), arguments),
                Argument.identifierFromRules(x.get(1), arguments)))
            .collect(Collectors.toList());
    }
}

class Argument {

    private final String label;
    private final String rawRules;
    private final List<String> rules;
    private final List<String> topRule;
    private final List<String> subargs;

    private String identifier;
    private String conclusion;

    public Argument(final String label, final String rules) {
        this.label = label;
        this.rawRules = rules;
        this.rules = new LinkedList<>(Arrays.asList(rules.trim().split(",")));
        this.topRule = new LinkedList<>(Arrays.asList(rules.trim().split(",")));
        this.subargs = new LinkedList<>();
    }

    public String getLabel() {
        return this.label;
    }

    public String getIdentifier() {
        return this.identifier;
    }

    public String getTopRule() {
        return this.topRule.get(0);
    }

    public String getConclusion() {
        return this.conclusion;
    }

    public List<String> getRules() {
        return this.rules;
    }

    public List<String> getSubargs() {
        return this.subargs;
    }

    public void setIdentifier(final String identifier) {
        this.identifier = identifier;
    }

    public void setConclusion(final String conclusion) {
        this.conclusion = conclusion;
    }

    public void addSubarg(final String subarg, final List<String> rules) {
        this.subargs.add(subarg);
        this.topRule.removeAll(rules);
    }

    public String getDescriptor() {
        return this.getIdentifier() + " : " +
                Stream.concat(this.getSubargs().stream(), this.topRule.stream())
                        .reduce((a, b) -> a + "," + b)
                        .orElse("") + " : " +
                this.getConclusion();
    }

    static String identifierFromRules(final String rawRules, final List<Argument> vertices) {
        return vertices.stream().filter(x -> x.rawRules.equals(rawRules))
                .map(Argument::getIdentifier)
                .findFirst()
                .orElseThrow(IllegalArgumentException::new);
    }

    static String labelFromIdentifier(final String identifier, final List<Argument> vertices) {
        return vertices.stream().filter(x -> x.identifier.equals(identifier))
                .map(Argument::getLabel)
                .findFirst()
                .orElseThrow(IllegalArgumentException::new);
    }

    static List<Argument> mineArguments(final Prolog engine) {

        final Struct labelling = engine.getTheory()
                .getClauses().stream()
                .filter(x -> x.match(engine.termSolve("argsLabelling(X, Y, Z)")))
                .map(x -> (Struct) x)
                .findAny()
                .orElseThrow(IllegalStateException::new);

        final Map<String, List<String>> rawVertices = ImmutableMap.of(
                "in", RegexHelpers.parseLabellingArg(labelling,0),
                "out", RegexHelpers.parseLabellingArg(labelling,1),
                "und", RegexHelpers.parseLabellingArg(labelling,2)
        );

        final List<Argument> verts = rawVertices.entrySet()
                .stream()
                .flatMap(x -> x.getValue().stream()
                        .map(y -> new Argument(x.getKey(), y)))
                .sorted(Comparator.comparing(x -> x.getRules().size()))
                .collect(Collectors.toList());

        IntStream.range(0, verts.size())
                .forEach(x -> verts.get(x).setIdentifier("A" + x));

        verts.stream()
                .filter(x -> x.getRules().size() > 1)
                .forEach(x -> {
                    final Argument subarg = verts.stream()
                            .filter(a -> !a.getIdentifier().equals(x.getIdentifier()))
                            .reduce((a, b) -> {
                                if (x.getRules().containsAll(b.getRules()) &&
                                        b.getRules().size() >= a.getRules().size())
                                    return b;
                                return a;
                            }).orElseThrow(IllegalStateException::new);

                    x.addSubarg(subarg.getIdentifier(), subarg.getRules());
                });

        final List<String> theory = Arrays.asList(
                engine.getTheory().getText().split("\\n"));

        verts.forEach(x ->
            x.setConclusion(
                theory.stream()
                    .map(y -> y.replaceAll("\\s+",""))
                    .filter(y -> y.startsWith(x.getTopRule() + ":"))
                    .map(y -> y.split("=>")[1])
                    .findAny()
                    .orElseThrow(IllegalStateException::new)));

        return verts;
    }
}

class RegexHelpers {

    public static List<String> parseLabellingArg(final Struct labelling, final int index) {
        return regexResults(labelling.getArg(index)
                .toString().replaceAll("^.|.$", ""));
    }

    public static List<String> regexResults(final String target) {
        final List<String> matches = new LinkedList<>();
        final Matcher m = Pattern
                .compile("(?<=\\[\\[).*?(?=\\])")
                .matcher(target);

        while(m.find()) {
            matches.add(m.group());
        }
        return matches;
    }
}