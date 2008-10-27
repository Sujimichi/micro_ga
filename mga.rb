#Micro Genetic Algorithm by Jeremy Comer
class MGA
  attr_accessor :population, :generations, :mutation_rate, :cross_over_rate

  def initialize args = {}
    @popsize = args[:popsize] || 30
    @gene_length = args[:gene_length] || 10
    @cross_over_rate = args[:cross_over_rate] || 0.7
    @mutation_rate = args[:mutation_rate] || 0.1
    @generations = args[:generations] || 400
    @population = Array.new(@popsize){ Array.new(@gene_length){ rand.round} }
  end

  def evolve
    @generations.times do
      select = (0..@popsize-1).sort_by{rand}[0,2] # Select two members at random
      select = select.sort_by {|ind| fitness(@population[ind]) }.reverse  #Sort by fitness
      @population[select.first].each_with_index do |gene,i| #Replace % of weaker member's genes with fitter member's.
        @population[select.last][i] = pos_mutate( rand<=@cross_over_rate ? gene : @population[select.last][i] )
      end
    end
  end

  def pos_mutate n
    return n if rand >= @mutation_rate/@gene_length
    (n-1).abs
  end

  def fitness genome
    f = 0
    genome.each {|g| f+=g}
    return f
  end
end

# *1: Note on Mutation rates
# Mutation rate can be given in terms of genes or genomes.  
# If a per gene mutation rate of 0.1 is used then 1 gene in a 10 bit genome will mutate, however the same per gene rate will cause 10 mutation in a 100 bit genome.  
# per_gene_rate = per_genome_rate/gene_length
#
# In this GA mutations are implemented on a per gene basis, but the value given in @muation_rate is a per genome value



