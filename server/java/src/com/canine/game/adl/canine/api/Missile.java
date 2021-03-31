/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class Missile {

  /* Members */

  private PosVel pv;
  private Duration remainingLife;

  /* Constructors */

  public Missile(PosVel pv, Duration remainingLife) {
    this.pv = Objects.requireNonNull(pv);
    this.remainingLife = Objects.requireNonNull(remainingLife);
  }

  public Missile() {
    this.pv = new PosVel();
    this.remainingLife = new Duration();
  }

  public Missile(Missile other) {
    this.pv = PosVel.FACTORY.create(other.pv);
    this.remainingLife = Duration.FACTORY.create(other.remainingLife);
  }

  /* Accessors and mutators */

  public PosVel getPv() {
    return pv;
  }

  public void setPv(PosVel pv) {
    this.pv = Objects.requireNonNull(pv);
  }

  public Duration getRemainingLife() {
    return remainingLife;
  }

  public void setRemainingLife(Duration remainingLife) {
    this.remainingLife = Objects.requireNonNull(remainingLife);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Missile)) {
      return false;
    }
    Missile other = (Missile) other0;
    return
      pv.equals(other.pv) &&
      remainingLife.equals(other.remainingLife);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + pv.hashCode();
    _result = _result * 37 + remainingLife.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private PosVel pv;
    private Duration remainingLife;

    public Builder() {
      this.pv = null;
      this.remainingLife = null;
    }

    public Builder setPv(PosVel pv) {
      this.pv = Objects.requireNonNull(pv);
      return this;
    }

    public Builder setRemainingLife(Duration remainingLife) {
      this.remainingLife = Objects.requireNonNull(remainingLife);
      return this;
    }

    public Missile create() {
      Builders.checkFieldInitialized("Missile", "pv", pv);
      Builders.checkFieldInitialized("Missile", "remainingLife", remainingLife);
      return new Missile(pv, remainingLife);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<Missile> FACTORY = new Factory<Missile>() {
    @Override
    public Missile create() {
      return new Missile();
    }

    @Override
    public Missile create(Missile other) {
      return new Missile(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Missile");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Missile> jsonBinding() {
      return Missile.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Missile> jsonBinding() {
    final Lazy<JsonBinding<PosVel>> pv = new Lazy<>(() -> PosVel.jsonBinding());
    final Lazy<JsonBinding<Duration>> remainingLife = new Lazy<>(() -> Duration.jsonBinding());
    final Factory<Missile> _factory = FACTORY;

    return new JsonBinding<Missile>() {
      @Override
      public Factory<Missile> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Missile _value) {
        JsonObject _result = new JsonObject();
        _result.add("pv", pv.get().toJson(_value.pv));
        _result.add("remainingLife", remainingLife.get().toJson(_value.remainingLife));
        return _result;
      }

      @Override
      public Missile fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new Missile(
          JsonBindings.fieldFromJson(_obj, "pv", pv.get()),
          JsonBindings.fieldFromJson(_obj, "remainingLife", remainingLife.get())
        );
      }
    };
  }
}
