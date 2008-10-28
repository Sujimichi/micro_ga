#Micro Genetic Algorithm by Jeremy Comer
class MGA
  attr_accessor :population, :generations, :mutation_rate, :cross_over_rate

  def initialize args = {}
    @popsize = args[:popsize] || 30
    @gene_length = args[:gene_length] || 10
    @cross_over_rate = args[:cross_over_rate] || 0.7
    @mutation_rate = args[:mutation_rate] || 0.1  #per genome muation rate (see readme)
    @generations = args[:generations] || 400
    @population = Array.new(@popsize){ Array.new(@gene_length){ 0*rand.round} }
  end

  def evolve
    @generations.times do
      select = (0..@popsize-1).sort_by{rand}[0,2].sort_by {|ind| fitness(@population[ind]) }.reverse  #Select two members at random and sort by fitness
      @population[select.last] = @population[select.last].zip(@population[select.first]).collect {|genes| pos_mutate(genes[(rand<0.7 ? 1 : 0)]) } #Replace % of weaker member's genes with fitter member's.
    end
  end

  def pos_mutate n
    return n if rand >= @mutation_rate/@gene_length #per gene based muation
    (n-1).abs #binary mutation; 1 -> 0, 0 -> 1
  end

  def fitness genome
    f = 0
    genome.each {|g| f+=g}
    return f #sum of genome
  end
end
